require_dependency 'projects_controller'

module  Patches
  module ProjectsControllerPatchRpca
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain  :settings, :filter_project
      end
    end
  end
  module ClassMethods
  end

  module InstanceMethods
    def settings_with_filter_project
      settings_without_filter_project
      setting = Setting.send "plugin_redmine_project_cf_autocomplete"
      @hash = Hash.new
      cf_options = setting[:choosed_cf].split('|')
      CustomField.where(:type=> "ProjectCustomField").order("name ASC").select{|col| setting[:choosed_cf].include?(col.id.to_s) }.each do |cf|
        projects = Project.visible
        available_tag = Array.new
        projects.each do |project|
          project.visible_custom_field_values.select{|coll| coll.custom_field.name == cf.name }.each do |custom_value|
            unless custom_value.value.blank?
              available_tag<<custom_value.value
            end
          end
        end
        @hash[cf.id.to_s] = available_tag
      end
    end

  end

end