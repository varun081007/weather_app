import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  

  @override
  void initState(){
    super.initState();
    getCurrentWeather();
  }
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName='London';
    final res= await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'
        ),
    );
    final data=jsonDecode(res.body);
    if (data['cod']!='200'){
      throw "An unexpecteed error occured";
    }
    
    //temp=data['list'][0]['main']['temp'];

    return data;
    }catch(e){
      throw e.toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("weather App",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){},
          icon: const Icon(Icons.refresh),)
        ],
      ),
      body:
       FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: const CircularProgressIndicator.adaptive()) ;
          }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          final data=snapshot.data!;
          final currentTemp=data['list'][0]['main']['temp'];
          final currentSky=data['list'][0]['weather'][0]['main'];
          final currentPressure=data['list'][0]['main']['pressure'];
          final  currentHumidity=data['list'][0]['main']['humidity'];
          final windSpeed=data['list'][0]['wind']['speed'];
          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter:ImageFilter.blur(sigmaX: 10,sigmaY: 10) ,
                      child:  Padding(
                        padding:   EdgeInsets.all(16.0),
                        child: Column(
                          children: [Text(
                            '$currentTemp K',
                          style: TextStyle(fontSize: 32,
                          fontWeight: FontWeight.bold),
                          ), 
                           SizedBox(height: 16,),
                          Icon(
                            currentSky=='Clouds'||currentSky=='Rain'?
                            Icons.cloud:Icons.sunny,
                            size: 64,
                          ),
                           SizedBox(height: 16,),
                          Text(
                            currentSky,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: const Text("weather forecast",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              //SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                //child: Row(
                 // children: [
                   // for(int i=0;i<5;i++)
                  //    HourlyForecastItem(
                  //      time:data['list'][i+1]['dt'].toString(),
                  ///      icon: data['list'][i+1]['weather'][0]['main']=='Clouds'||
                  /////            data['list'][i+1]['weather'][0]['main']=='Rain'?Icons.cloud:Icons.sunny,
                    //    temperature: data['list'][i+1]['main']['temp'].toString(),
                   //   ),
                    
                    
                //  ],
               // ),
             // ),
             SizedBox(
              height: 120,
               child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder:(context, index) {
                  final hourlyForecast=data['list'][index+1];
                  final hourlySky=data['list'][index+1]['weather'][0]['main'];
                  final hourlyTemp=hourlyForecast['main']['temp'].toString();
                  final time=DateTime.parse(hourlyForecast['dt_txt']);
                  return HourlyForecastItem(
                    time: DateFormat.Hm().format(time),
                    temperature: hourlyTemp,
                    icon: hourlySky=='Clouds'||hourlySky=='Rain'?Icons.cloud:Icons.sunny,
                  );
                },
                           ),
             ), 
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: const Text("Additional Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                       child: Column(
                        children: [
                          const SizedBox(width: 80,),
                          Icon(
                          Icons.water_drop_rounded,
                          size: 32,
                        ),
                        const SizedBox(height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: const Text("Humidity",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            ),
                          ),
                        const SizedBox(height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: Text(currentHumidity.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                      ],
                    ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(width: 60,),
                          Icon(
                          Icons.air,
                          size: 32,
                        ),
                        const SizedBox(height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: const Text("Wind Speed",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            ),
                          ),
                          const SizedBox(height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: Text(windSpeed.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                      ],
                    ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(width: 40,),
                          Icon(
                          Icons.beach_access,
                          size: 32,
                        ),
                        const SizedBox(width: 5,height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: const Text("Pressure",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            ),
                          ),
                          const SizedBox(width: 60,height: 16,), 
                          Align(
                            alignment: Alignment.center,
                            child: Text(currentPressure.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          ),
                      ],
                    ),
                    )
                  ],
                ),
              )
            ],
          ),
               );
        },
       )
    );
  }
}
