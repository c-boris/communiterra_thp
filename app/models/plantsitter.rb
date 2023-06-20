class Plantsitter < User
  has_many :plant_sittings_as_asker, foreign_key: :asker_id, class_name: 'PlantSitting'
  has_many :kept_plants_as_asker, through: :plant_sittings_as_asker, source: :kept_plant
end
