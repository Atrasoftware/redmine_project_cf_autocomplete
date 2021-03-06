require_dependency 'projects_controller'

module  Patches
  module ProjectsControllerPatchRpca
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.class_eval do
        before_filter :get_hash, :only=>[:new, :settings, :copy]
      end
    end
  end
  module ClassMethods
  end

  module InstanceMethods

    def get_hash
      setting = Setting.send "plugin_redmine_project_cf_autocomplete"
      @hash = Hash.new
      cf_options = setting[:choosed_cf].split('|')
      CustomField.where(:type=> "ProjectCustomField").order("name ASC").select{|col| setting[:choosed_cf].include?(col.id.to_s) }.each do |cf|

          projects_id = Project.visible.pluck :id
          # available_tag = Array.new
          available_tag = CustomValue.where(customized_type: 'Project').
              where(customized_id: projects_id).
              where(custom_field_id: cf.id).pluck( :value)
          # projects.each do |project|
          #   project.visible_custom_field_values.select{|coll| coll.custom_field.name == cf.name }.each do |custom_value|
          #     unless custom_value.value.blank?
          #       if cf.field_format != 'list'
          #         available_tag<< custom_value.value.html_safe
          #       else
          #         available_tag<< custom_value.value
          #       end
          #     end
          #   end

          @hash[cf.id.to_s] = available_tag.uniq
        # end
      end


    end

  end

end
