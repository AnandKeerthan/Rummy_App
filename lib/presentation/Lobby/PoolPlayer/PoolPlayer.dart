import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';

class PoolPlayer extends StatefulWidget {
  const PoolPlayer({Key? key}) : super(key: key);

  @override
  State<PoolPlayer> createState() => _PoolPlayerState();
}

class _PoolPlayerState extends State<PoolPlayer> with TickerProviderStateMixin {
  TabController? _tabController;
  int changeIndex = 0;
  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.yellowAccent,
              // margin: const EdgeInsets.only(top: 17),
              height: AppSize.height(context, 5.5),
              width: AppSize.width(context, 45),
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
                      : _tabController!.index == 1
                          ? BoxDecoration(
                              color: ColorConstant.apptheme,
                              borderRadius: BorderRadius.only())
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
                        "61",
                        fontSize: 12,
                        color: _tabController!.index == 0
                            ? ColorConstant.white
                            : Colors.black,
                      ),
                    ),
                    Tab(
                      child: AppText(
                        "101",
                        fontSize: 12,
                        color: _tabController!.index == 1
                            ? ColorConstant.white
                            : Colors.black,
                      ),
                    ),
                    Tab(
                      child: AppText(
                        "201",
                        fontSize: 12,
                        color: _tabController!.index == 2
                            ? ColorConstant.white
                            : Colors.black,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: AppSize.height(context, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class PoolPlayerGame extends StatefulWidget {
  const PoolPlayerGame({Key? key}) : super(key: key);

  @override
  State<PoolPlayerGame> createState() => _PoolPlayerGameState();
}

class _PoolPlayerGameState extends State<PoolPlayerGame>
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
            SizedBox(
              height: AppSize.height(context, 1),
            ),
          ],
        ),
      ),
    );
  }
}
