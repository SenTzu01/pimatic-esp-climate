module.exports = {
  title: "pimatic-lg-smart-tv Device config schemas"
  EsPimaticTemperatureSensorDevice: {
    title: "Temperature Sensor Device"
    description: "Temperature Sensor Device configuration"
    type: "object"
    properties:
      temperatureVariable:
        description: "Temperature Variable populated by the ESP sensor"
        type: "string"
  }
  EsPimaticHumiditySensorDevice: {
    title: "Humidity Sensor Device"
    description: "Humidity Sensor Device configuration"
    type: "object"
    extensions: ["xLink","xAttributeOptions"]
    properties:
      humidityVariable:
        description: "Humidity Variable populated by the ESP sensor"
        type: "string"
  }
}