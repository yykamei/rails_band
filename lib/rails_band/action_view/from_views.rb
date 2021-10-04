# frozen_string_literal: true

module RailsBand
  module ActionView
    # FromViews provides a sole method  #from_views to delete the prefix of 'app/views/' from the passed string.
    module FromViews
      private

      def from_views(string)
        string.delete_prefix(views_prefix)
      end

      def views_prefix
        @views_prefix ||= Rails.root.join('app/views/').to_path
      end
    end
  end
end
