require 'fastlane/action'
require_relative '../helper/android_emulator_helper'

module Fastlane
  module Actions
    module SharedValues
    end

    class AndroidEmulatorRemoveAction < Action
      def self.run(params)
        Actions::AndroidSdkLocateAction.run(params)
        sdk_dir = Actions.lane_context[SharedValues::ANDROID_SDK_DIR]
        UI.message("Deleting emulator...")
        FastlaneCore::CommandExecutor.execute(
          command: "#{sdk_dir}/tools/bin/avdmanager delete avd -n '#{params[:name]}'",
          print_all: true,
          print_command: false
        )
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Stop an Android Emulator"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :sdk_dir,
                                       env_name: "ANDROID_SDK_DIR",
                                       description: "Path to the Android SDK DIR",
                                       default_value: Actions.lane_context[SharedValues::ANDROID_SDK_DIR],
                                       optional: false,
                                       verify_block: proc do |value|
                                         UI.user_error!("No ANDROID_SDK_DIR given, pass using `sdk_dir: 'sdk_dir'`") unless value and !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :device,
                                       env_name: "FL_ANDROID_DEVICE",
                                       optional: true,
                                       description: "Use the device or emulator with the given serial number or qualifier"),
        ]
      end

      def self.authors
        ["Josh Luongo"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
