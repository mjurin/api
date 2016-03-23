ActiveAdmin.register User do
  permit_params :id, :firstname, :lastname, :email

  filter :firstname_or_lastname_or_email_cont, label: 'Search'

  filter :firstname
  filter :lastname
  filter :email

  index do
    selectable_column

    column :id
    column :email
    column :firstname
    column :lastname

    actions
  end

  form do |f|
    inputs "Basic information" do
      input :firstname
      input :lastname
      input :email
      if object.new_record?
        input :password
        input :password_confirmation
      end
    end

    actions
  end

end
