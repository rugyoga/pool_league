ActiveAdmin.register Player do
  permit_params :name, :percentage

  index do
    selectable_column
    column :name
    column :team
    column :percentage
    actions
  end
end
