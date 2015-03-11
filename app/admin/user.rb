ActiveAdmin.register User do


  permit_params :email, :role, :phone, :about

  form do |f|
    f.input :email
    f.input :role
    f.input :phone
    f.input :about
    f.actions
  end

end
