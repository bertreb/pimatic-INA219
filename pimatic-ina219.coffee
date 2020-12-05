module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  M = env.matcher
  _ = require('lodash')
  INA219 = require('ina219')

  class Ina219Plugin extends env.plugins.Plugin
    init: (app, @framework, @config) =>

      pluginConfigDef = require './pimatic-ina219-config-schema'

      @deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass('Ina219Device', {
        configDef: @deviceConfigDef.Ina219Device,
        createCallback: (config, lastState) => new Ina219Device(config, lastState)
      })

  class Ina219Device extends env.devices.Device

    constructor: (config, lastState) ->
      @config = config
      @id = @config.id
      @name = @config.name

      @attributes = {}

      super()


    destroy:() =>
      super()

  ina219Plugin = new Ina219Plugin
  return ina219Plugin
