ActiveAdmin.register Venue do
  permit_params :name, :address, :tables

  index do
    selectable_column
    column :name
    column :address
    column :tables
    actions
  end
  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :address
      f.input :tables
    end
    f.actions
  end
end
