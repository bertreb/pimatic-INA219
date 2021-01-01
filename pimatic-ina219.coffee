module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  M = env.matcher
  ina219 = require('ina219')

  class Ina219Plugin extends env.plugins.Plugin
    init: (app, @framework, @config) =>

      pluginConfigDef = require './pimatic-ina219-config-schema'

      @deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass('Ina219Device', {
        configDef: @deviceConfigDef.Ina219Device,
        createCallback: (config, lastState) => new Ina219Device(config, lastState, @config.debug)
      })

  class Ina219Device extends env.devices.Device

    attributes:
      voltage:
        description: "Voltage"
        type: "number"
        unit: 'V'
        acronym: 'V'
      current:
        description: "Current"
        type: "number"
        unit: 'mA'
        acronym: 'A'

    constructor: (config, lastState, logging) ->
      @config = config
      @id = @config.id
      @name = @config.name

      @interval = @config.interval ? 10000
      @address = @config.address ? 0x40
      @device = @config.device ? 1

      @_voltage = lastState?.voltage?.value
      @_current = lastState?.current?.value

      ina219.init(@address, @device)
      ina219.enableLogging(logging)

      requestValues = () =>
        env.logger.debug "Requesting sensor values"
        try
          ina219.getBusVoltage_V((_volts) =>
            if Number.isNaN(_volts) then _volts = 0
            env.logger.debug "Voltage (V): " + _volts
            @emit "voltage", _volts
            ina219.getCurrent_mA((_current) =>
              if Number.isNaN(_current) then _current = 0
              env.logger.debug "Current (mA): " + _current
              @emit "current", _current
            )
          )
        catch err
          env.logger.debug "Error getting sensor values: #{err}"

      ina219.calibrate32V1A(() => # kan ook ina219.calibrate32V2A
        requestValues()
        @requestValueIntervalId = setInterval( requestValues, @interval)
      )

      super()

    getVoltage: -> Promise.resolve(@_voltage)
    getCurrent: -> Promise.resolve(@_current)

    destroy:() =>
      clearInterval(@requestValueIntervalId)
      super()

  ina219Plugin = new Ina219Plugin
  return ina219Plugin
