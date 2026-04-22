# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Economy
          module Runners
            module AttentionEconomy
              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)

              def add_demand(label:, demand_type:, priority:, cost:, roi: 0.5, **)
                d = attention_budget.create_demand(
                  label:       label,
                  demand_type: demand_type,
                  priority:    priority,
                  cost:        cost,
                  roi:         roi
                )
                log.info("[attention] demand added: id=#{d.id} label=#{label} priority=#{priority} cost=#{cost}")
                { created: true, demand: d.to_h }
              rescue ArgumentError => e
                log.warn("[attention] add_demand failed: #{e.message}")
                { created: false, reason: e.message }
              end

              def allocate_demand(demand_id:, amount: nil, **)
                result = attention_budget.allocate(demand_id: demand_id, amount: amount)
                if result[:allocated]
                  log.info("[attention] allocated: demand_id=#{demand_id} amount=#{result[:amount]} remaining=#{result[:remaining]}")
                else
                  log.debug("[attention] allocation failed: demand_id=#{demand_id} reason=#{result[:reason]}")
                end
                result
              end

              def deallocate_demand(demand_id:, **)
                result = attention_budget.deallocate(demand_id: demand_id)
                log.debug("[attention] deallocated: demand_id=#{demand_id} freed=#{result[:freed]}")
                result
              end

              def recover_budget(amount: nil, **)
                opts   = amount ? { amount: amount } : {}
                result = attention_budget.recover!(**opts)
                log.debug("[attention] recovery: delta=#{result[:recovered]} spent=#{result[:spent]}")
                result
              end

              def prioritized_demands(**)
                demands = attention_budget.prioritized_demands
                log.debug("[attention] prioritized_demands: count=#{demands.size}")
                { demands: demands.map(&:to_h), count: demands.size }
              end

              def best_roi_demands(limit: 5, **)
                demands = attention_budget.best_roi(limit: limit)
                log.debug("[attention] best_roi: limit=#{limit} count=#{demands.size}")
                { demands: demands.map(&:to_h), count: demands.size }
              end

              def rebalance_budget(**)
                result = attention_budget.rebalance
                log.info("[attention] rebalance: freed=#{result[:rebalanced]} spent=#{result[:spent]}")
                result
              end

              def attention_economy_status(**)
                report = attention_budget.budget_report
                log.debug("[attention] economy status: utilization=#{report[:utilization]} demands=#{report[:demand_count]}")
                report
              end

              def attention_snapshot(**)
                attention_budget.to_h
              end

              private

              def attention_budget
                @attention_budget ||= Helpers::AttentionBudget.new
              end
            end
          end
        end
      end
    end
  end
end
