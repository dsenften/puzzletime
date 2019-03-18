# frozen_string_literal: true

#  Copyright (c) 2006-2017, Puzzle ITC GmbH. This file is part of
#  PuzzleTime and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/puzzletime.


module Api
  # Subclass the `JsonapiController` to implement a new endpoint for the json api.
  #
  # The serializer is determined based on the controller namespace and on the return value of `::model_class`
  # and can be customized by implementing the `::serializer` method.
  # See also `DryCrud::GenericModel::ClassMethods#model_class`
  #
  class JsonapiController < ManageController
    include Apidocs::Annotations::Controller

    class IncludeError < StandardError
      def self.===(exception)
        exception.class == ArgumentError &&
          exception.message.match(/is not specified as a relationship on/)
      end
    end

    # render a json:api error response when an illegal include is requested
    rescue_from IncludeError do |exception|
      render_error(exception.message, detail: 'Fix or remove the offending include')
    end

    # render a json:api error response when accessing an unauthorized resource
    rescue_from CanCan::AccessDenied do |exception|
      render_error(exception.message, status: :forbidden)
    end

    class << self
      def serializer_class_name
        namespace = name.deconstantize
        "#{namespace}::#{model_class.name}Serializer"
      end

      # Returns the serializer class used to serialize the entries to json:api (Can be overwritten in subclass)
      def serializer
        serializer_class_name.safe_constantize
      end
    end

    delegate :serializer, :serializer_class_name, to: 'self.class'

    def index
      render json: serializer.new(entries, include: include_param).serializable_hash,
             content_type: Mime::Type.lookup_by_extension(:jsonapi)
    end

    def show
      render json: serializer.new(entry, include: include_param).serializable_hash,
             content_type: Mime::Type.lookup_by_extension(:jsonapi)
    end

    # Render an error response as specified in https://jsonapi.org/format/#errors
    def render_error(title, detail: nil, code: :error, status: 422, **opts)
      error_payload = {
        errors: [
          {
            id: request.uuid,
            status: status.to_s,
            code: code,
            title: title,
            detail: detail
          }.merge(opts)
        ]

      }
      render json: error_payload,
             status: status,
             content_type: Mime::Type.lookup_by_extension(:jsonapi)
    end

    private

    def include_param
      params.permit(:include)[:include].try(:split, ',')
    end
  end
end
