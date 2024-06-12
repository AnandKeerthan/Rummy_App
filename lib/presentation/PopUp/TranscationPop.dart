// import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
// import 'package:dsrummy/app_export/app_export.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class TranscationAlert extends StatefulWidget {
//   Msg item;
//   TranscationAlert({Key? key, required this.item}) : super(key: key);
//
//   @override
//   State<TranscationAlert> createState() => _TranscationAlertState();
// }
//
// class _TranscationAlertState extends State<TranscationAlert> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.white,
//       contentPadding: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(
//           side: BorderSide(color: Colors.orange, width: 1),
//           borderRadius: BorderRadius.all(Radius.circular(30.0))),
//       content: Container(
//         height: AppSize.height(context, 55),
//         width: MediaQuery.sizeOf(context).width,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(30.0))),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                             child: Center(
//                                 child: Icon(
//                               Icons.close,
//                               color: ColorConstant.apptheme,
//                             )),
//                             decoration: ShapeDecoration(
//                                 shape: CircleBorder(
//                                     side: BorderSide(
//                               width: 1,
//                               color: ColorConstant.apptheme,
//                             )))),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: AppSize.height(context, 1),
//                   ),
//                   Divider(),
//                   Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText("Status",
//                               fontSize: 12, fontWeight: FontWeight.w500),
//                           AppText("Date",
//                               fontSize: 12, fontWeight: FontWeight.w500),
//                         ],
//                       ),
//                       SizedBox(
//                         height: AppSize.height(context, 1.5),
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                             widget.item.status == "true"
//                                 ? "Confirmed"
//                                 : "Pending",
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13,
//                             color: ColorConstant.gren,
//                           ),
//                           AppText(
//                               CommonFunctions.formatDateTimeGMTIndia(
//                                   widget.item.createdAt!),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Divider(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText("From",
//                               fontSize: 12, fontWeight: FontWeight.w500),
//                           AppText("To",
//                               fontSize: 12, fontWeight: FontWeight.w500),
//                         ],
//                       ),
//                       SizedBox(
//                         height: AppSize.height(context, 1.5),
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           (widget.item.type! != "game" &&
//                                   widget.item.type! != "winner" &&
//                                   widget.item.type! != "refund")
//                               ? AppText(
//                                   CommonFunctions.maskedAddress(
//                                       widget.item.fromAddress.toString()),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500)
//                               : AppText("-", fontWeight: FontWeight.w500),
//                           (widget.item.type! != "game" &&
//                                   widget.item.type! != "winner" &&
//                                   widget.item.type! != "refund")
//                               ? AppText(
//                                   CommonFunctions.maskedAddress(
//                                       widget.item.toAddress.toString()),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500)
//                               : AppText("-", fontWeight: FontWeight.w500),
//                         ],
//                       ),
//                       Divider(),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText("Type",
//                               fontSize: 12, fontWeight: FontWeight.w500),
//                           AppText(widget.item.type.toString(),
//                               color: ColorConstant.gren,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500),
//                           SizedBox(
//                             height: AppSize.height(context, 1.5),
//                           ),
//                         ],
//                       ),
//                       Divider(),
//                     ],
//                   ),
//                   SizedBox(
//                     height: AppSize.height(context, 1.5),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(
//                                 5.0) //                 <--- border radius here
//                             ),
//                         border: Border.all(
//                           color: ColorConstant.apptheme,
//                         )),
//                     child: Padding(
//                       padding: const EdgeInsets.all(5.0),
//                       child: Column(
//                         children: [
//                           Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [],
//                               ),
//                               SizedBox(
//                                 height: AppSize.height(context, 1.5),
//                               ),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AppText(
//                                     "gas fee",
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   (widget.item.type! != "game" &&
//                                           widget.item.type! != "winner" &&
//                                           widget.item.type! != "refund")
//                                       ? AppText(widget.item.gasFee.toString(),
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500)
//                                       : AppText("-",
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w500),
//                                 ],
//                               ),
//                               Divider(),
//                               SizedBox(
//                                 height: AppSize.height(context, 1.5),
//                               ),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   AppText(
//                                     "Amount",
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   AppText(
//                                       widget.item.type == "game"
//                                           ? widget.item.amount.toString()
//                                           : widget.item.amount.toString(),
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w700),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
