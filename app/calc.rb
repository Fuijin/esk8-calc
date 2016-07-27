class Calc
  LIPO_VOLTS = 3.7

  R = 0.00003728226

  def self.calc!(store)
    cell_volts = LIPO_VOLTS
    batt_cells = store.get "batt-cells"
    batt_volts = (batt_cells * cell_volts).round 1
    store.set "out-battery-volts", batt_volts

    motor_kv = store.get "motor-kv"
    raw_efficiency = store.get "system-efficiency"
    efficiency = raw_efficiency / 100

    motor_rpm = motor_kv * batt_volts
    motor_rpm_weighted = motor_rpm * efficiency
    store.set "out-motor-rpm", motor_rpm
    store.set "out-motor-rpm-weighted", motor_rpm_weighted

    motor_teeth    = store.get "motor-pulley-teeth"
    wheel_teeth    = store.get "wheel-pulley-teeth"
    gear_ratio     = motor_teeth / wheel_teeth
    gear_ratio_out = (wheel_teeth / motor_teeth).round(1)
    store.set "out-gear-ratio", gear_ratio_out

    wheel_size = store.get "wheel-size"
    top_speed_mph   = motor_rpm * wheel_size * Math::PI * R * gear_ratio
    top_speed_kmh   = top_speed_mph * 1.609344
    top_speed_mph_w = top_speed_mph * efficiency
    top_speed_kmh_w = top_speed_kmh * efficiency
    store.set "out-top-speed", top_speed_mph
    store.set "out-top-speed-weighted", top_speed_mph_w
  end
end
