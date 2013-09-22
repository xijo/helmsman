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

    # Private part of actionpack/lib/action_view/helpers/translation_helper.rb
    # Wrapped for clarification what that does.
    def expand_i18n_key(key)
      scope_key_by_partial(key)
    end

    def helm(key, options = {}, &block)
      actions     = options.fetch(:actions)     { [] }
      controllers = options.fetch(:controllers) { [key] }
      disabled    = options.fetch(:disabled)    { false }
      current     = options.fetch(:current)     { current_state_by_controller(*controllers, actions: actions) }
      visible     = options.fetch(:visible)     { true }
      url         = options[:url]
      i18n_key    = expand_i18n_key(".#{key}")

      entry = Helm.new(disabled: disabled, current: current, visible: visible, i18n_key: i18n_key, url: url)

      entry.additional = capture(entry, &block) if block_given?
      entry
    end
  end
end
