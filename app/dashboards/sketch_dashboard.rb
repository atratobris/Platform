require "administrate/base_dashboard"

class SketchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    draft: Field::BelongsTo.with_options(class_name: "Draftsman::Draft"),
    id: Field::Number,
    links: Field::String.with_options(searchable: false),
    boards: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    draft_id: Field::Number,
    published_at: Field::DateTime,
    trashed_at: Field::DateTime,
    status: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :draft,
    :id,
    :links,
    :boards,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :draft,
    :id,
    :links,
    :boards,
    :created_at,
    :updated_at,
    :draft_id,
    :published_at,
    :trashed_at,
    :status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :draft,
    :links,
    :boards,
    :draft_id,
    :published_at,
    :trashed_at,
    :status,
  ].freeze

  # Overwrite this method to customize how sketches are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(sketch)
  #   "Sketch ##{sketch.id}"
  # end
end