// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyWeatherAdapter extends TypeAdapter<MyWeather> {
  @override
  final int typeId = 0;

  @override
  MyWeather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyWeather(
      temp: fields[0] as double,
      feelsLike: fields[1] as double,
      tempMin: fields[2] as double,
      tempMax: fields[3] as double,
      pressure: fields[4] as double,
      humidity: fields[5] as double,
      windSpeed: fields[6] as double,
      description: fields[7] as String,
      icon: fields[8] as String,
      name: fields[9] as String,
      main: fields[10] as String,
      seaLevel: fields[11] as double,
      grndLevel: fields[12] as double,
      sunrise: fields[13] as DateTime,
      sunset: fields[14] as DateTime,
      dt: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MyWeather obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.temp)
      ..writeByte(1)
      ..write(obj.feelsLike)
      ..writeByte(2)
      ..write(obj.tempMin)
      ..writeByte(3)
      ..write(obj.tempMax)
      ..writeByte(4)
      ..write(obj.pressure)
      ..writeByte(5)
      ..write(obj.humidity)
      ..writeByte(6)
      ..write(obj.windSpeed)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.icon)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.main)
      ..writeByte(11)
      ..write(obj.seaLevel)
      ..writeByte(12)
      ..write(obj.grndLevel)
      ..writeByte(13)
      ..write(obj.sunrise)
      ..writeByte(14)
      ..write(obj.sunset)
      ..writeByte(15)
      ..write(obj.dt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyWeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
