module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  commons = require('pimatic-plugin-commons')(env)
  
  # Device class representing the ESPimatic Temperature Sensor
  class EsPimaticTemperatureSensorDevice extends env.devices.TemperatureSensor

    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @_temperature = lastState?.temperature?.value || 0
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug || false
      
      super()
      
      @plugin.framework.variableManager.on('variableValueChanged', @_setValue)
    
    _setValue: (variable, value) =>
      @_setTemperature(value) if variable.name is @config.temperatureVariable
    
    destroy: () ->
      @plugin.framework.variableManager.removeListener('variableValueChanged', @_setValue)
      super()