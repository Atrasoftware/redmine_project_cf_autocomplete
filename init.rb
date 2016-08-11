Redmine::Plugin.register :redmine_project_cf_autocomplete do
  name 'Redmine Project Cf Autocomplete plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/Atrasoftware/redmine_project_cf_autocomplete'

  settings :default=>{
        :choosed_cf=>''
    }, :partial => 'settings/setting_cf'

  class Hooks < Redmine::Hook::ViewListener
    render_on :view_projects_form, :partial => 'hooks/js_cf'
  end

end
Rails.application.config.to_prepare do
  ProjectsController.send(:include, Patches::ProjectsControllerPatchRpca)
end