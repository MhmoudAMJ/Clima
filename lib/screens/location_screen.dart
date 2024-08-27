import 'package:clima2/screens/city_screen.dart';
import 'package:clima2/services/weather.dart';
import 'package:clima2/utilities/constants.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.locationWeather});
  final dynamic locationWeather;
  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  late int temperature, temperatureF, condition;
  late String weatherIcon, cityName, weatherMessage;
  WeatherModel weather = WeatherModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(
      () {
        if (weatherData == null) {
          temperature = 0;
          temperatureF = 0;
          weatherIcon = 'error';
          weatherMessage = 'unable to get weather data';
          cityName = '';
          return;
        }
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        temperatureF = ((temperature * (9 / 5)) + 32).toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        cityName = weatherData['name'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {}
                      var weatherData = await weather.getCityWeather(typedName);
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°C/$temperatureF°F',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 1.0),
                child: Text(
                  '$weatherMessage in $cityName!',
                  textAlign: TextAlign.center,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
