# frozen_string_literal: true

# !/usr/bin/env ruby
# built-in black list pods (long import path not supported
# you can use hmap_black_pod_list to add other pods
$hmap_black_pod_list = %w[
  GoogleUtilities
  MeshPipe
  GoogleDataTransport
  FirebaseCoreDiagnostics
  FirebaseCore
  FirebaseCrashlytics
  FirebaseInstallations
  CoreDragon
  Objective-LevelDB
]

$hmap_white_list = %w[
]

$strict_mode = false
$prebuilt_hmap_for_pod_targets = true

module Pod
  class Podfile
    module DSL
      def set_hmap_black_pod_list(pods)
        $hmap_black_pod_list.concat(pods) if !pods.nil? && pods.size.positive?
      end

      # if use strict mode, main project can only use `#import <PodTargetName/SomeHeader.h>`
      # `#import <SomeHeader.h>` will get 'file not found' error
      # as well as PodTarget dependent on other PodTarget
      def set_hmap_use_strict_mode
        $strict_mode = true
      end

      # turn off prebuilt hmap for targets in pod project except the `main` target
      def turn_prebuilt_hmap_off_for_pod_targets
        $prebuilt_hmap_for_pod_targets = false
      end

      def set_hmap_white_list(pods)
        $hmap_white_list.concat(pods) if !pods.nil? && pods.size.positive?
      end
    end
  end
end
