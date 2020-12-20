module.exports = {
  title: "pimatic-ina219 device config schemas"
  Ina219Device: {
    title: "Ina219Device config options"
    type: "object"
    extensions: ["xLink", "xAttributeOptions"]
    properties:{
      device:
        description: "Device file to use (prefix /dev/i2c- is automatically added)"
        type: "number"
        default: 1
      address:
        description: "Address of the sensor"
        type: "string"
        enum: ["0x40","0x41","0x44","0x45"]
        default: "0x40"
      interval:
        interval: "Sensor read interval in ms"
        type: "integer"
        default: 10000
    }
  }
}
