# CalibrationHealthStatus.msg
# Sensor health status response from PX4 for calibration purposes

uint64 timestamp
uint8 target_system
uint8 target_component

# Sensor health bitmasks (each sensor has bit position based on PX4 health_component_t enum)
# Bit positions (events::px4::enums::health_component_t):
# 0: battery
# 1: motors_escs (motors and ESCs) 
# 2: parachute
# 3: accel (3D accelerometer)
# 4: gyro (3D gyroscope)
# 5: magnetometer (3D compass)
# 6: gps
# 7: remote_control
# 8: local_position_estimate (AHRS)
# 9: absolute_pressure (barometer)
# 10: differential_pressure (airspeed sensor)
# 19: avoidance (obstacle avoidance)

uint64 sensors_present_mask    # Which sensors are physically present
uint64 sensors_warning_mask    # Which sensors have warnings  
uint64 sensors_error_mask      # Which sensors have errors