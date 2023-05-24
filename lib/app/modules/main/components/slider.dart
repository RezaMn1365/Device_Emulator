import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderWidget extends StatelessWidget {
  bool isVertical;
  double positionValue;
  double maxZoomLevel = 2.0;
  final double newVal = 0;
  Function onChanged;
  SliderWidget(
      {required this.maxZoomLevel,
      required this.isVertical,
      required this.onChanged,
      required this.positionValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? SfSlider.vertical(
            shouldAlwaysShowTooltip: true,
            activeColor: Colors.blue,
            showDividers: true,
            stepSize: 1,
            showTicks: true,
            minorTicksPerInterval: 80,
            edgeLabelPlacement: EdgeLabelPlacement.auto,
            enableTooltip: true,
            inactiveColor: Colors.grey,
            min: 1.0,
            max: maxZoomLevel <= 1 ? 1.10 : maxZoomLevel,
            value: positionValue,
            interval: 1,
            showLabels: true,
            onChanged: (dynamic newValue) {
              onChanged(newValue);
              positionValue = newValue;
              // setState(() {
              //   _value = newValue;
              // });
            },
          )
        : SfSlider(
            shouldAlwaysShowTooltip: true,
            activeColor: Colors.blue,
            showDividers: true,
            stepSize: 1,
            showTicks: true,
            minorTicksPerInterval: 10,
            edgeLabelPlacement: EdgeLabelPlacement.inside,
            enableTooltip: true,
            inactiveColor: Colors.grey,
            min: 0.0,
            max: 360.0,
            value: positionValue,
            interval: 30,
            showLabels: true,
            onChanged: (dynamic newValue) {
              onChanged(newValue);
              positionValue = newValue;
              // setState(() {
              //   _value = newValue;
              // });
            },
          );
    // !isVertical
    //     ? const SizedBox(height: 15)
    //     : SizedBox(
    //         height: 0,
    //       ),
    // !isVertical
    //     ? const Text('Camera Motion')
    //     : SizedBox(
    //         height: 0,
    //       ),
  }
}
