class PlanReqModel {
    String? itemType;
    int? qty;
    int? itemId;
    int? facilityId;
    bool? isRenewal;
    bool? startAfterCurrent;

    PlanReqModel({
        this.itemType,
        this.qty,
        this.itemId,
        this.facilityId,
        this.isRenewal,
        this.startAfterCurrent,
    });


     Map<String, dynamic> toJson(bool includeExtra ) {
     final data = {
    "item_id": itemId,
    "item_type": itemType,
    "qty": qty,
   
  };

  if (includeExtra) {
    data.addAll({
       "facility_id": facilityId,
      // "facility_id": facilityId,
      "isRenewal": isRenewal,
      "startAfterCurrent": startAfterCurrent,
    });
  }

  return data;
  }

}
