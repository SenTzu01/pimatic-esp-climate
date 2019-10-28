module.exports = (env) ->
  
  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  commons = require('pimatic-plugin-commons')(env)
  t = require('decl-api').types
  
  # Device class representing the ESPimatic Humidity Sensor
  class EsPimaticHumiditySensorDevice extends env.devices.TemperatureSensor
    
    _humidity: undefined
    
    actions:
      getHumidity:
        description: "Returns the current humidity"
        returns:
          humidity:
            type: t.number

    attributes:
      humidity:
        description: "The measured humidity"
        type: t.number
        unit: '%'
        acronym: 'Hrel'
    
    constructor: (@config, @plugin, lastState) ->
      @_base = commons.base @, @config.class
      @_humidity = lastState?.humidity?.value || 0
      @id = @config.id
      @name = @config.name
      @debug = @plugin.debug || false
      
      super()
      
      @plugin.framework.variableManager.on('variableValueChanged', @_setValue)
    
    _setValue: (variable, value) =>
      @_setHumidity(Number(value)) if variable.name is @config.humidityVariable

    _setHumidity: (value) ->
      @_humidity = value
      @emit 'humidity', value
    
    getHumidity: -> Promise.resolve(@_humidity)
    
    destroy: () ->
      @plugin.framework.variableManager.removeListener('variableValueChanged', @_setValue)
      super()
    
    template: "temperature"