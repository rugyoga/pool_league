ActiveAdmin.register Team do
  permit_params :name, :venue_id
  index do
    selectable_column
    column :name
    column :venue_id
    column :strength
    actions
  end
end
