# webOS plugin
module.exports = (env) ->
  
  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)
    
  deviceConfigTemplates = [
    {
      "name": "ESPimatic Temperature Sensor",
      "class": "EsPimaticTemperatureSensorDevice"
    },
    {
      "name": "ESPimatic Humidity Sensor",
      "class": "EsPimaticHumiditySensorDevice"
    }
  ]
  
  actionProviders = [
  ]
  
  # ###ESPClimatePlugin class
  class ESPClimatePlugin extends env.plugins.Plugin
    constructor: () ->
    
    init: (app, @framework, @config) =>
      @debug = @config.debug || false
      @_base = commons.base @, 'Plugin'

      # register devices
      deviceConfigDef = require("./device-config-schema")
      
      for device in deviceConfigTemplates
        className = device.class
        # convert camel-case classname to kebap-case filename
        filename = className.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()
        classType = require('./devices/' + filename)(env)
        @_base.debug "Registering device class #{className}"
        @framework.deviceManager.registerDeviceClass(className, {
          configDef: deviceConfigDef[className],
          createCallback: @_callbackHandler(className, classType)
        })
      
      
      # register actions
      for provider in actionProviders
        className = provider.replace(/(^[a-z])|(\-[a-z])/g, ($1) ->
          $1.toUpperCase().replace('-','')) + 'Provider'
        classType = require('./actions/' + provider)(env)
        @_base.debug "Registering action provider #{className}"
        @framework.ruleManager.addActionProvider(new classType @framework)
      
      # auto-discovery
      @framework.deviceManager.on 'discover', () =>
        #@_base.debug("Starting discovery")
        #@framework.deviceManager.discoverMessage( 'pimatic-lg-smart-tv', "Searching for LG Smart TV" )
    
    _callbackHandler: (className, classType) ->
      # this closure is required to keep the className and classType
      # context as part of the iteration
      return (config, lastState) =>
        return new classType(config, @, lastState, @framework)

  # ###Finally
  # Create a instance of my plugin
  # and return it to the framework.
  return new ESPClimatePlugin