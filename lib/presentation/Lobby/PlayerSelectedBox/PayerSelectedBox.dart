import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';

class PlayerSelectesbox extends StatefulWidget {
  const PlayerSelectesbox({Key? key}) : super(key: key);

  @override
  State<PlayerSelectesbox> createState() => _PlayerSelectesboxState();
}

class _PlayerSelectesboxState extends State<PlayerSelectesbox>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int changeIndex = 0;
  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.yellowAccent,
              // margin: const EdgeInsets.only(top: 17),
              height: AppSize.height(context, 5.5),
              width: AppSize.width(context, 25),
              decoration: BoxDecoration(
                  color: ColorConstant.gray300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  )),
              child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  unselectedLabelStyle: TextStyle(color: ColorConstant.black),
                  labelStyle: TextStyle(color: ColorConstant.white),
                  indicatorSize: TabBarIndicatorSize.tab,
                  physics: const NeverScrollableScrollPhysics(),
                  indicator: _tabController!.index == 0
                      ? BoxDecoration(
                          color: ColorConstant.apptheme,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ))
                      : BoxDecoration(
                          color: ColorConstant.apptheme,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          )),
                  onTap: (v) {
                    setState(() {
                      changeIndex = _tabController!.index;
                    });
                  },
                  tabs: [
                    Tab(
                      child: AppText(
                        "2",
                        color: _tabController!.index == 0
                            ? ColorConstant.white
                            : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Tab(
                      child: AppText(
                        "4",
                        color: _tabController!.index == 1
                            ? ColorConstant.white
                            : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
