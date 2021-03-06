import QtQuick 2.0
import "Assets"

Rectangle {
    id: root
    property var sensors: NULL
    property var chart: NULL
    property var tutorial
    property var storageDB: NULL
    property var sample_rate: sample_slider.value
    property var refresh_rate: refresh_slider.value

    width: 160;
    height: 480;
    color: "#ffc2cd"

    Text {
        id: width_label
        x: 8
        y: 8
        color: "#eeeeee"
        text: "<b>Line Width:</b> " + sensors.items[0].width.toFixed(0) + "px"
    }
    Slider {
        id: linewidth_slider
        x: 8
        y: 25
        width: parent.width - 2*x
        height: width_label.y+16
        border_width : 1
        handle_width : 24
        radius: 8
        stepSize: 1
        maximum: 10
        minimum: 1
        onChanged: {
            for(var x=0;x<sensors.items.length;x++)
                 {
                 sensors.items[x].width = newval;
                 }
            chart.update();
        }
//        MouseArea{
//            anchors.fill: parent
//            onClicked: {
//                console.log("clicked")
//                mouse.accepted = false
//            }
//        }

//        Tooltip{
//            anchors.fill: parent
//            text: "change the linewidth"
//        }

        Binding { target: linewidth_slider; property: "value"; value: sensors.items[0].width; when: !linewidth_slider.dragActive;}
//        Component.onCompleted: value = sensors.items[0].width;
    }


    Text {
        id:refresh_label
        x: 8
        y: 68
        color: "#eeeeee"
        text: "<b>Refreshrate:</b> " + chart.refreshrate.toFixed(0) + "ms"
    }

    Slider {
        id: refresh_slider
        x: refresh_label.x
        y: refresh_label.y+16
        width: linewidth_slider.width
        height: linewidth_slider.height
        border_width : 1
        handle_width : 24
        radius: 8
        stepSize: 100
        maximum: 5000
        minimum: 100
        onChanged: {
            chart.refreshrate = Math.round(newval);
        }
        Binding { target: refresh_slider; property: "value"; value: chart.refreshrate; when: !refresh_slider.dragActive;}
//        Component.onCompleted: {console.log("chart.refreshrate="+chart.refreshrate);value = chart.refreshrate;}
    }


    Text {
        id:sample_label
        x: 8
        y: 128
        color: "#eeeeee"
        text: "<b>Samplerate:</b> " + chart.samplerate.toFixed(0) + "ms"
    }

    Slider {
        id: sample_slider
        x: sample_label.x
        y: sample_label.y+16
        width: linewidth_slider.width
        height: linewidth_slider.height
        border_width : 1
        handle_width : 24
        radius: 8
        stepSize: 100
        maximum: 5000
        minimum: 100
        onChanged: {
            chart.samplerate = Math.round(newval);
        }

        Binding { target: sample_slider; property: "value"; value: chart.samplerate; when: !sample_slider.dragActive;}
//        Component.onCompleted: value = chart.samplerate;
    }

    Rectangle{x:parent.width-2; width:2;height:parent.height;color:"#aaffa500"}

    Timer{
        interval: 1000;
        running: true;
        repeat: true
        onTriggered:
            {
            var count=0;
            var buffer=0;
            for(var x=0;x<sensors.items.length;x++)
                 {
                 count += sensors.items[x].samples.length;
                  buffer += sensors.items[x].max_samples;
                 }
            numsamples.text = "<b>Debug Info</b><br>Buffer: "+(count/buffer*100).toFixed(2)+"%";
            }
    }

    Item{
        width: parent.width
        x:8
        y:200
//        height: 200
//        anchors.bottom: parent.bottom
        Column{
            spacing: 12
            Text{
                width: linewidth_slider.width;
                color:"#eeeeee";
                wrapMode: Text.WordWrap
                text:"<b>About pwnsensor</b><br>Version: " + VERSION + "<br>created by Henry Thasler<br>pwnsensor@thasler.org<br>";
            }
            Button{
                width: linewidth_slider.width;
                height: 24
                text: "show tutorial";
                onClicked: root.tutorial.visible = true
            }
            Text{id:numsamples; color:"#eeeeee";text:"<b>Debug Info</b><br>Buffer: 0%"}
        }
    }
}
