# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module FeatureBinding
          module Runners
            module FeatureBinding
              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)

              def register_feature(id:, dimension:, value:, source: :perception, salience: 0.5, **)
                log.debug("[feature_binding] register: id=#{id} dim=#{dimension} val=#{value}")
                feature = field.register_feature(id: id, dimension: dimension, value: value, source: source,
                                                 salience: salience)
                if feature
                  { success: true, feature: feature.to_h, total_features: field.feature_count }
                else
                  { success: false, reason: :limit_reached }
                end
              end

              def bind_features(feature_ids:, attention: false, **)
                log.debug("[feature_binding] bind: features=#{feature_ids} attention=#{attention}")
                obj = field.bind(feature_ids: feature_ids, attention: attention)
                if obj
                  { success: true, object: obj.to_h, total_objects: field.object_count }
                else
                  { success: false, reason: :insufficient_features }
                end
              end

              def attend_object(object_id:, **)
                log.debug("[feature_binding] attend: object=#{object_id}")
                obj = field.attend(object_id: object_id.to_sym)
                if obj
                  { success: true, object: obj.to_h }
                else
                  { success: false, reason: :not_found }
                end
              end

              def unbind_object(object_id:, **)
                log.debug("[feature_binding] unbind: object=#{object_id}")
                removed = field.unbind(object_id: object_id.to_sym)
                { success: removed }
              end

              def features_of_object(object_id:, **)
                features = field.features_of(object_id: object_id.to_sym)
                log.debug("[feature_binding] features_of: object=#{object_id} count=#{features.size}")
                { success: true, features: features, count: features.size }
              end

              def objects_with(feature_id:, **)
                objects = field.objects_with_feature(feature_id: feature_id)
                log.debug("[feature_binding] objects_with: feature=#{feature_id} count=#{objects.size}")
                { success: true, objects: objects, count: objects.size }
              end

              def illusory_conjunctions(**)
                illusions = field.illusory_conjunctions
                log.debug("[feature_binding] illusory: #{illusions.size}")
                { success: true, illusory: illusions, count: illusions.size }
              end

              def unbound_features(**)
                unbound = field.unbound_features
                log.debug("[feature_binding] unbound: #{unbound.size}")
                { success: true, unbound: unbound, count: unbound.size }
              end

              def search_features(dimension:, value: nil, **)
                results = field.search_by_dimension(dimension: dimension, value: value)
                log.debug("[feature_binding] search: dim=#{dimension} found=#{results.size}")
                { success: true, results: results, count: results.size }
              end

              def update_feature_binding(**)
                log.debug('[feature_binding] tick')
                field.decay_all
                { success: true, features: field.feature_count, objects: field.object_count }
              end

              def feature_binding_stats(**)
                log.debug('[feature_binding] stats')
                { success: true, stats: field.to_h }
              end

              private

              def field
                @field ||= Helpers::BindingField.new
              end
            end
          end
        end
      end
    end
  end
end
