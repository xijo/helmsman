module Helmsman
  module ViewHelper
    # Returns true if one of the given controllers match the actual one.
    # If actions are set they are taken into account.
    def current_state_by_controller(*given_controller_names, actions: [])
      if given_controller_names.any? { |name| name == controller_name.to_sym }
        if actions.present?
          Array(actions).include?(action_name.to_sym)
        else
          true
        end
      end
    end

    # Indicates if for the given conditions the helm should be highlighted.
    # Examples:
    #   Given we are in pictures controller and action index
    #   highlight_helm?(:pictures)                          # true
    #   highlight_helm?(:foobar)                            # false
    #   highlight_helm?(pictures: :index)                   # true
    #   highlight_helm?(pictures: [:index, :show])          # true
    #   highlight_helm?(pictures: [:index, :show], :foobar) # true
    def highlight_helm?(conditions)
      Array(conditions).any? do |condition|
        case condition
        when Symbol, String
          condition.to_s == controller_name
        when Array
          if condition.first.to_s == controller_name
            Array(condition.last).any? { |given| given.to_s == action_name }
          end
        else
          raise TypeError,
            "invalid format for highlight options, "\
            "expected Symbol, Array or Hash got #{conditions.class.name}"
        end
      end
    end

    def helm_i18n_scope(scope, &block)
      @helm_i18n_scope = scope
      yield
      @helm_i18n_scope = nil
    end

    # Private part of actionpack/lib/action_view/helpers/translation_helper.rb
    # Wrapped for clarification what that does.
    def helm_expand_i18n_key(key)
      if @helm_i18n_scope
        [@helm_i18n_scope, key].join
      else
        scope_key_by_partial(key)
      end
    end

    def helm(key, options = {}, &block)
      actions        = options.fetch(:actions)   { [] }
      highlight_opts = options.fetch(:highlight) { key }
      disabled       = options.fetch(:disabled)  { false }
      current        = options.fetch(:current)   {
        highlight_helm?(highlight_opts)
      }
      visible        = options.fetch(:visible)   { true }
      url            = options[:url]
      i18n_scope     = helm_expand_i18n_key('.')

      entry = Helm.new(
        disabled:  disabled,
        current:    current,
        visible:    visible,
        i18n_key:   key,
        i18n_scope: i18n_scope,
        url:        url,
        li_class:   options[:li_class],
        tooltip:   options[:tooltip],
      )

      entry.additional = capture(entry, &block) if block_given?
      entry
    end
  end
end
