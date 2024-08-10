// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 0;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      name: fields[19] as String,
      country: fields[18] as String,
      main: fields[0] as String,
      description: fields[1] as String,
      icon: fields[2] as String,
      temp: fields[3] as double,
      feelsLike: fields[4] as double,
      tempMin: fields[5] as double,
      tempMax: fields[6] as double,
      pressure: fields[7] as int,
      humidity: fields[8] as int,
      visibility: fields[11] as int,
      windSpeed: fields[12] as double,
      windDeg: fields[13] as int,
      clouds: fields[14] as int,
      dt: fields[15] as DateTime,
      sunrise: fields[16] as DateTime,
      sunset: fields[17] as DateTime,
      seaLevel: fields[9] as int,
      grndLevel: fields[10] as int,
      timezone: fields[20] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.main)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.temp)
      ..writeByte(4)
      ..write(obj.feelsLike)
      ..writeByte(5)
      ..write(obj.tempMin)
      ..writeByte(6)
      ..write(obj.tempMax)
      ..writeByte(7)
      ..write(obj.pressure)
      ..writeByte(8)
      ..write(obj.humidity)
      ..writeByte(9)
      ..write(obj.seaLevel)
      ..writeByte(10)
      ..write(obj.grndLevel)
      ..writeByte(11)
      ..write(obj.visibility)
      ..writeByte(12)
      ..write(obj.windSpeed)
      ..writeByte(13)
      ..write(obj.windDeg)
      ..writeByte(14)
      ..write(obj.clouds)
      ..writeByte(15)
      ..write(obj.dt)
      ..writeByte(16)
      ..write(obj.sunrise)
      ..writeByte(17)
      ..write(obj.sunset)
      ..writeByte(18)
      ..write(obj.country)
      ..writeByte(19)
      ..write(obj.name)
      ..writeByte(20)
      ..write(obj.timezone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
