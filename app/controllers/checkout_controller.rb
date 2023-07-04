class CheckoutController < ApplicationController
  def create
    @delivery_price = current_user.cart.listings.joins(:delivery).sum('deliveries.delivery_price')
    @total = current_user.cart.cart_listings.sum { |cart_listing| cart_listing.listing.price * cart_listing.quantity }

    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: ((@total + @delivery_price) * 100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
      ],
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )
    redirect_to @session.url, allow_other_host: true
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    @total = current_user.cart.cart_listings.sum { |cart_listing| cart_listing.listing.price * cart_listing.quantity }

    order = Order.create!(user_id: current_user.id, order_total: @total)
    order.save!
    OrderMailer.order_confirmation(current_user, order).deliver_now

    cart_listings = current_user.cart.cart_listings

    cart_listings.each do |cart_listing|
      listing = cart_listing.listing
      quantity_ordered = cart_listing.quantity
      remaining_quantity = listing.remaining_quantity - quantity_ordered

      if remaining_quantity >= 0
        listing.update_columns(sold_quantity: listing.sold_quantity + quantity_ordered, remaining_quantity: remaining_quantity)
        OrderListing.create!(
          order_id: order.id,
          listing_id: cart_listing.listing_id,
          quantity: cart_listing.quantity
        )
        flash[:notice] = "Le paiement a bien été effectué."
      else
        flash[:alert] = "Le produit #{listing.listing_title} n'est pas disponible dans la quantité demandée."
        redirect_to listings_url and return
      end
    end

    current_user.cart.cart_listings.destroy_all

    redirect_to listings_url
  end

  def cancel
    cart_listings = current_user.cart.cart_listings

    cart_listings.each do |cart_listing|
      listing = cart_listing.listing
      listing.update(remaining_quantity: listing.remaining_quantity + cart_listing.quantity)
    end

    current_user.cart.cart_listings.destroy_all

    flash[:notice] = 'Le panier a été annulé et les quantités ont été restaurées.'
    redirect_to carts_path
  end
end