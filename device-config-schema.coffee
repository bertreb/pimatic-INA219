module.exports = {
  title: "pimatic-ina219 device config schemas"
  Ina219Device: {
    title: "Ina219Device config options"
    type: "object"
    extensions: ["xLink", "xAttributeOptions"]
    properties:{
    properties:
      device:
        description: "Device file to use"
        type: "string"
        default: "/dev/i2c-0"
      address:
        description: "Address of the sensor"
        type: "string"
        default: "0x40"
      interval:
        interval: "Sensor read interval in ms"
        type: "integer"
        default: 10000
  }  }
}
