//
//  LoginUseCaseTests.swift
//  PlantMedic
//
//  Created by Magnatesage  on 01/08/25.
//

import XCTest
@testable import PlantMedic

final class LoginUseCaseTests: XCTestCase {

    class MockAuthRepository: AuthRepositoryProtocol {
        var shouldSucceed = true

        func login(email: String, password: String) async throws -> String {
            if shouldSucceed {
                return "Mock Login Success"
            } else {
                throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Mock failure"])
            }
        }
    }

    func testLoginSuccess() async throws {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldSucceed = true
        let useCase = LoginUseCase(repository: mockRepo)

        let result = try await useCase.execute(email: "test@example.com", password: "password123")
        XCTAssertEqual(result, "Mock Login Success")
    }

    func testLoginFailure() async {
        let mockRepo = MockAuthRepository()
        mockRepo.shouldSucceed = false
        let useCase = LoginUseCase(repository: mockRepo)

        do {
            _ = try await useCase.execute(email: "test@example.com", password: "fail")
            XCTFail("Expected failure")
        } catch {
            XCTAssertEqual(error.localizedDescription, "Mock failure")
        }
    }
}
/*

 class ItemDetailsViewController: UIViewController {

 //MARK: - IBOutlets
 @IBOutlet weak var lblTitle: UILabel!
 @IBOutlet weak var lblDescription: UILabel!
 @IBOutlet weak var btnClose: UIButton!

 @IBOutlet weak var btnFavourite: UIButton!
 @IBOutlet weak var imgItem: UIImageView!

 @IBOutlet weak var viewStepper: UIView!
 @IBOutlet weak var btnCustmise: UIButton!

 @IBOutlet weak var tblMealItems: UITableView!
 @IBOutlet weak var btnAddToOrder: CornerRadiusButton!
 @IBOutlet weak var lblNuturation: UILabel!
 @IBOutlet weak var btnMakeItMeal: CornerRadiusButton!
 @IBOutlet weak var viewSize: UIView!
 @IBOutlet weak var lblSelectedItemList: UILabel!

 @IBOutlet weak var viewMealItmes: UIView!
 @IBOutlet weak var viewNuturation: UIView!

 @IBOutlet weak var vwVarientHeight:NSLayoutConstraint!
 @IBOutlet weak var colletionVarient:UICollectionView!
 @IBOutlet weak var btnNutritionInfo: UIButton!

 //MARK: - Variables
 var selectedItem:ItemSelectedDetails?

 //    var maxPrefixHeight:CGFloat = 0
 var isRunAsMealAction = false
 var isShowDippingDressing = false
 var strSelectedDressingDipping = ""
 var oldPrice : Double = 0
 var pricePerItem:Double = 0
 var sumOfMods:Double = 0.0
 var editCartEntityCompletion:(()->())?
 var itemDetailScreenType:EnumItemDetailsScreenType = .forCartAdd
 var isCancleAttachment : Bool = false

 var itemData:ItemListData!{
 didSet{
 selectedItem = ItemSelectedDetails(parentItem: itemData, allBoxItems: [],varientDetails: [],selectedVarient: nil, selectedBoxItem: [])

 if !(itemData.modifiers?.customize ?? []).isEmpty{
 self.selectedItem?.selectedCustomiser = getCustomiseData(customiseData: itemData.modifiers?.customize ?? [])
 }else{
 self.selectedItem?.selectedCustomiser = nil
 }
 if !(itemData.modifiers?.dressing ?? []).isEmpty{
 //                self.selectedItem?.selectedDressingDipping = getCustomiseData(customiseData: itemData.modifiers?.dressing ?? [])

 }else if !(itemData.modifiers?.dipping ?? []).isEmpty{
 //                self.selectedItem?.selectedDressingDipping = getCustomiseData(customiseData: itemData.modifiers?.dipping ?? [])

 }else{
 self.selectedItem?.selectedDressingDipping = nil
 }
 }
 }

 var itemType : EnumMainItemLogic = .none
 var thStepper: THStepper?

 @IBOutlet weak var imgType: UIImageView!
 //MARK: - Variables for Meals
 var mealItem : BundleMealList?
 var mealModificationData: MealParentData?
 var comboObj : ComboData?
 var mealDrinkBundleEntity:Entity?
 var mealItemSelectionCompletion: ((MealParentData)->())?
 var comboItemSelectioCompletion: ((ComboData)->())?
 var offerItemSelectionCompletion: ((OffersModel)->())?
 var cancelTapped:(()->())?

 //MARK: - IBActions

 @IBAction func btnNutritionClick(_ sender:UIButton?){
 var url = ""
 if selectedItem?.selectedVarient != nil{
 url = selectedItem?.selectedVarient?.nutritional_allergens ?? ""
 }else{
 url = itemData.nutritional_allergens ?? ""
 }
 self.showWebView(strUrl: url)
 }

 @IBAction func btnCloseClick(_ sender: Any) {
 self.navigationController?.popViewController(animated: true)
 }

 @IBAction func btnCustomNavigationClick(_ sender: UIButton) {
 modifireFlow(itemData1: selectedItem!)
 }


 func selectedMinimumModifirelist(inputCustomizer: [Customize])-> [Customize] {
 var array = [Customize]()
 inputCustomizer.forEach({ custObj in
 var coutOfSelected = 0
 custObj.modifierList?.forEach({ list in
 if list.isSelected == true || list.currentValue ?? 0 > 0 {
 coutOfSelected = coutOfSelected + 1
 }
 })
 if coutOfSelected > 0{
 array.append(custObj)
 }
 })

 return array
 }
 private func setBoxItemsDefaultItemsNotChange(){
 // SET BOX ITEMS IF BOX HAS DEFAULT ITEMS
 if (itemData.isMultibox ?? false) && (selectedItem?.selectedBoxItem ?? []).isEmpty{
 var boxItems = selectedItem?.allBoxItems
 boxItems?.enumerated().forEach({ item in
 let boxItem = itemData.box?.first(where: {$0.item == item.element.id})
 boxItems?[item.offset].currentValue = boxItem?.defaultState
 })
 selectedItem?.selectedBoxItem = boxItems
 }
 }
 /// Description
 /// - Parameter sender: <#sender description#>
 @IBAction func btnAddToOrderClick(_ sender: UIButton) {
 sender.disableFor()

 //        let arrCustomiseMandatory =  self.selectedItem?.selectedCustomiser?.filter({$0.isMandatory == true})
 //
 //        arrCustomiseMandatory?.forEach({ arrcustomise in
 //            arrcustomise.modifireDetails?.forEach({ list in
 //                if list.is_disable == true {
 //                    self.itemData.is_disable = true
 //                    self.showAlert(errorMessage: "Some of the modifire is not availalbe")
 //                    return
 //                }
 //            })
 //        })

 //        let arrMandatoryWithDefaultState = arrCustomiseMandatory?.map({$0.modifireDetails?.first?.is_disable == true})

 switch itemType{
 case .onlyVarient:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }
 return
 }
 break

 case .mandatoryCustomiser:
 if selectedItem?.mandatoryCustomiser != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser) ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 //                        self.view.alpha = 0.5
 //                        self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                            self.view.alpha = 1
 //                            self.btnCustomNavigationClick(self.btnCustmise)
 //                        }
 return
 }

 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }

 return
 }
 break
 case .mandatoryDressingDipping:
 if selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire  = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping) ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifire){ [weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }

 return
 }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 return
 }
 break
 case .mandatoryCustmDressDipp:
 if selectedItem?.mandatoryCustomiser != nil && selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)  ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})

 let selectedModifireOther = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem!.selectedDressingDipping) ?? [Customize]()).compactMap({$0.id})

 let mandatoryModifireOther = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})
 //                    if (selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:))) && (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))) {
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)){
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }else if selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:)){
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifireOther){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }
 //                        self.view.alpha = 0.5
 //                        self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                            self.view.alpha = 1
 //                            self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                        }
 //                        self.showAlert(errorMessage: "You have not selected all mandatory customiser..") {
 //                        }
 //                        return
 //                    }

 //                    if selectedModifire != mandatoryModifire && selectedModifireOther != mandatoryModifireOther {
 //                        self.showAlert(errorMessage: "You have not selected all mandatory customiser and dressing dipping..") {
 //
 //                        }
 //                        return
 //                    }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 return
 }
 case .multibox:

 var currentVaueTotle = 0

 if selectedItem?.selectedBoxItem?.count ?? 0 > 0 {
 selectedItem?.selectedBoxItem?.forEach { listItem in
 currentVaueTotle += listItem.currentValue ?? 0
 }
 if currentVaueTotle <  self.itemData.maxQuantity ?? 0 {
 self.showAlert(errorMessage: "Please select minimum \(self.itemData.maxQuantity ?? 0) box quentity")
 return
 }
 }
 else {
 currentVaueTotle = 0

 selectedItem?.allBoxItems?.forEach { listItem in
 currentVaueTotle += listItem.currentValue ?? 0
 }
 if currentVaueTotle <  self.itemData.maxQuantity ?? 0 {
 self.showAlert(errorMessage: "Please select minimum \(self.itemData.maxQuantity ?? 0) box quentity")
 return
 }
 }


 //                if let selectedbox = selectedItem?.allBoxItems {
 //                    if selectedItem?.allBoxItems?.count ?? 0 <
 //                        selectedbox.forEach { itemD in
 //                            print(itemD.maxQuantity)
 //                            print(selectedItem?.selectedBoxItem?.count)
 //                        if itemD.maxQuantity ?? 0 < selectedItem?.selectedBoxItem?.count ?? 0 {
 //                            self.showAlert(errorMessage: "TTTTTTTTT")
 //                        }
 //                    }
 //                }

 break
 case .none:
 break
 case .varientMandatoryCustomiser:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }
 //self.showAlert(errorMessage: "Please select one of the varient first for order", completion: nil)
 return
 }
 if selectedItem?.mandatoryCustomiser != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)!).compactMap({$0.id}) //selectedItem!.selectedCustomiser?.compactMap({$0.id}).sorted(by: {$0 > $1}) ?? []
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 //  LOGIC FOR GET MODIFIRE CATEGORY get name.
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 return
 }
 case .varientMandatoryDressingDipping:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }
 //self.showAlert(errorMessage: "Please select one of the varient first for order", completion: nil)
 return
 }
 if selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire =  self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping)!).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }

 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 // self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return

 }
 case .varientMandatoryCustmDressDipp:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }
 //self.showAlert(errorMessage: "Please select one of the varient first for order", completion: nil)
 return
 }else if selectedItem?.mandatoryCustomiser != nil && selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire =
 self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)!).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})

 let selectedModifireOther = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping)!).compactMap({$0.id})
 let mandatoryModifireOther = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})

 //                    if (selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:))) && (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))) {
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)){
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }else if (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))){
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifireOther){[weak self] in
 guard let self = self else {return}
 self.btnAddToOrderClick(sender)
 }
 return
 }
 //                        self.view.alpha = 0.5
 //                        self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                            self.view.alpha = 1
 //                            self.btnCustomNavigationClick(self.btnCustmise)
 //                        }
 //self.showAlert(errorMessage: "You have not selected all mandatory customiser..") {
 //}
 //                        return
 //                    }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 //self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return
 }
 }

 let accessToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
 if !accessToken.isEmpty {

 switch itemDetailScreenType {
 case .forCartAdd,.forComboItemSelection, .forComboRecusiveItemSelection( _), .forComboAddFromReviewScreen:
 //First Check user alredy canceled this attachemnt or not
 // if comboObj == nil means we are not executing flow of combo, and if we are inside the combo flow then we are not going to show attachments.
 if comboObj == nil  {
 if !self.isCancleAttachment {
 if itemData.attachments?.count ?? 0 > 0{
 let idsOfAttachment : [String] = (itemData.attachments?.map({$0.attachment ?? ""}) ?? [""])

 let arrAttachment = Tbl_Menu_Attachment_List.getRecords(arrIds: idsOfAttachment, in: _coreDataShared.getContext())

 if (itemData.variants?.count ?? 0 == 0) {
 self.showAttachment(attachments: arrAttachment ?? [], parentAttachment: nil)
 }
 else {
 getAttachmentOnVariants(attachments: arrAttachment ?? []) { arr  in
 if !arr.isEmpty {
 self.showAttachment(attachments: arr, parentAttachment: nil)
 }else{
 self.isCancleAttachment = true
 self.btnAddToOrderClick(sender)
 }

 }
 }
 return
 }
 }
 }
 else {
 if !self.isCancleAttachment {
 if itemData.attachments?.count ?? 0 > 0{
 let idsOfAttachment = itemData.attachments?.map({$0.attachment ?? ""}) ?? [""]
 let data = Tbl_Promotion.getRecords(arrIds: idsOfAttachment, in: _coreDataShared.getContext())
 var arrAttachment = [Attachment]()
 data?.forEach({ shrObjOfer in
 let shrObjAttachment = Attachment(attachmentType: .promotion, entity: shrObjOfer.comboId , title: shrObjOfer.title ?? "N/A", image: shrObjOfer.image ?? "", id: shrObjOfer._id ?? "", start_date: shrObjOfer.start_date, end_date: shrObjOfer.end_date, display_start_time: shrObjOfer.display_start_time, display_end_time: shrObjOfer.display_end_time, days: shrObjOfer.days, apply_on_restaurant: shrObjOfer.apply_on_restaurant)
 arrAttachment.append(shrObjAttachment)
 })

 if (itemData.variants?.count ?? 0 == 0) {
 self.showAttachment(attachments: arrAttachment, parentAttachment: nil)
 }
 else {
 getAttachmentOnVariants(attachments: arrAttachment) { arr  in
 if !arr.isEmpty {
 self.showAttachment(attachments: arr, parentAttachment: nil)
 }else{
 self.isCancleAttachment = true
 self.btnAddToOrderClick(sender)
 }

 }
 }
 return
 }
 }
 }
 case .editCartItem( _), .forMealItemChange, .forMealEditCustomiser( _), .forMealRootCustomiserChange( _), .forChangeOfferItem( _ , _, _), .editBoosterItem( _), .forComboItemChange( _), .forComboEditSubItemCustomiser( _ , _), .forMealItemSelection, .forCartAddFromLoyalityWithBooster( _), .forCartAddFromLoyalityWithOffers( _),.forEditOfferItemCustomiser( _,  _,  _), .forComboMealAdd:
 break
 }


 switch itemDetailScreenType {
 case .forCartAdd:
 _progressBar.showProgressBar(uiView: self.view)
 CartModule().callCheckDeviceAtCurrentMenu { [weak self] obj in
 guard let self = self else{return}
 DispatchQueue.main.async {
 _progressBar.hideProgressBar(uiView: self.view)
 }

 if let obj = obj{
 if obj.order_accept{
 let cartObj = self.getCartObject()
 sender.isEnabled = false
 CartModule().addToCart(entity: self.itemData, objAddCart: cartObj, actionType: .item, forVC: self) { result in
 sender.isEnabled = true
 if result == true{
 //                                    self.showAlert(errorMessage: "Added to cart") {
 //                                    }
 }else{
 self.showAlert(errorMessage: "Something went wrong while updating cart") {
 }
 }
 self.navigationController?.popViewController(animated: true)
 }
 }else{
 self.showAlert(errorMessage: obj.message ?? Global.alertMessageSomethingWentWrong) {
 }
 }

 }else{
 self.showAlert(errorMessage: "Something went wrong while checking device time") {
 }
 }
 }

 case .forComboMealAdd:
 break
 case .editCartItem(let cartData):
 let cartObj = getCartObject()
 CartModule().updateCartEntityItemMods(cartObj: cartData, objAddCart: cartObj, actionType: .item, forVC: self){ result in
 if !result{
 self.showAlert(errorMessage: "Something went wrong while updating cart") {
 }
 }
 self.editCartEntityCompletion?()
 self.navigationController?.popViewController(animated: true)
 }
 break
 case .forComboItemSelection,.forComboRecusiveItemSelection(_):
 self.addSubItemToComboDataForComboSubItem_ADD_CHANGE(editedIndex: nil)
 break
 case .forComboItemChange(let editedIndex):
 self.addSubItemToComboDataForComboSubItem_ADD_CHANGE(editedIndex: editedIndex)
 break
 case .forMealItemSelection,.forMealItemChange:

 let subItems = mealModificationData?.MealSubItem  ?? []
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.parentBundleId == mealItem?.id}){
 var varientPrice:Double? = Global.getPriceForItem(price: itemData.upchargePrice, mealID: mealModificationData?.strMealId ?? "", arrayPromoptionPrice: itemData.mealUpchargePrice ?? [])
 if selectedItem?.selectedVarient != nil{
 if !(mealDrinkBundleEntity?.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 varientPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: selectedItem?.selectedVarient?.mealUpchargePrice ?? []) ?? 0
 }else{
 // VARIENT SATISFIED THEN IT'S INCLUDED
 varientPrice = 0
 }
 }

 let shrEntity = MealBundleSubEntityData(strMealId: mealModificationData?.strMealId,
 strSelectedEntityId: itemData.id,
 strSelectedBundleEntityID: mealDrinkBundleEntity?.id,
 parentBundleId: mealItem?.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.title ?? "",
 Quentity: mealModificationData?.Quentity,
 PricePerItem: self.pricePerItem,
 Price: self.pricePerItem * Double(mealModificationData?.Quentity ?? 0),
 baseItemPrice: varientPrice ?? 0,
 selectedVarient: selectedItem?.selectedVarient,
 mealVarientUpcharge: varientPrice ?? 0,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 itemType: itemData.itemType)

 mealModificationData?.MealSubItem?[currentSubItemIndex] = shrEntity
 mealItemSelectionCompletion?(self.mealModificationData!)

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }

 case .forMealEditCustomiser(let subEntityData):
 let accessToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
 if !accessToken.isEmpty {
 if let curentBundleIndex = mealModificationData?.MealSubItem?.firstIndex(where: {$0.parentBundleId == subEntityData.parentBundleId}){

 var varientPrice:Double? = Global.getPriceForItem(price: itemData.upchargePrice, mealID: mealModificationData?.mealObj?.meal ?? "", arrayPromoptionPrice: itemData.mealUpchargePrice ?? [])
 if selectedItem?.selectedVarient != nil{
 if !(mealDrinkBundleEntity?.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 varientPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: selectedItem?.selectedVarient?.mealUpchargePrice ?? []) ?? 0
 }else{
 // VARIENT SATISFIED THEN IT'S INCLUDED
 varientPrice = 0
 }
 }

 self.mealModificationData?.MealSubItem?[curentBundleIndex].selectedDressingDipping = self.selectedItem?.selectedDressingDipping

 self.mealModificationData?.MealSubItem?[curentBundleIndex].arrEntityCustomise = self.selectedItem?.selectedCustomiser

 self.mealModificationData?.MealSubItem?[curentBundleIndex].selectedVarient = self.selectedItem?.selectedVarient

 var title = Tbl_Menu_Varient_List.getRecords(id: selectedItem?.selectedVarient?.variantType ?? "", in: _coreDataShared.getContext())?.first?.name ?? ""

 //                                title += " \(itemData.title ?? "")"

 self.mealModificationData?.MealSubItem?[curentBundleIndex].itemTitle = itemData.title ?? ""

 self.mealModificationData?.MealSubItem?[curentBundleIndex].Price = oldPrice

 self.mealModificationData?.MealSubItem?[curentBundleIndex].mealVarientUpcharge = varientPrice ?? 0

 self.mealModificationData?.MealSubItem?[curentBundleIndex].PricePerItem = pricePerItem

 mealItemSelectionCompletion?(mealModificationData!)

 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 }
 }
 else {
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .addToCartWithoutLogin) { isSuccess in
 self.view.alpha = 1
 Global.setLoginAsRoot()
 }

 }
 break
 case .forComboEditSubItemCustomiser(let subEntityData,let editedSubItemIndex):
 let accessToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
 if !accessToken.isEmpty {

 let subItems = comboObj?.arrComboBundleItems ?? []
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let entity = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 let price = ((entity.applyPrice ?? false) ? entity.price :  itemData.price) ?? 0

 var itemPrice:Double? = Global.getPriceForItem(price: price, mealID: comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? itemData.mealUpchargePrice :  itemData.promotionPrice) ?? [])

 if selectedItem?.selectedVarient != nil{
 if (entity.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 // CHECK VARIENT PRICE

 let varientPrice = ((entity.applyPrice ?? false) ? entity.price :  selectedItem?.selectedVarient?.price) ?? 0

 itemPrice = Global.getPriceForItem(price: varientPrice,mealID: self.comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 }
 }

 // SET BOX ITEMS IF BOX HAS DEFAULT ITEMS
 setBoxItemsDefaultItemsNotChange()


 //CHANGE RECURSIVE EDIT CODE
 let shrEntity = MealBundleSubEntityData(strMealId: subEntityData.strMealId,
 strSelectedEntityId: subEntityData.strSelectedEntityId,
 strSelectedBundleEntityID: itemData.parentComboBundleEntityId,
 parentBundleId: subEntityData.parentBundleId,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.getItemName(selectedVariant: self.selectedItem?.selectedVarient),
 Quentity: Int(thStepper?.value ?? 0),
 PricePerItem: self.pricePerItem,
 Price: self.pricePerItem * Double(thStepper?.value ?? 0),
 baseItemPrice: itemPrice ?? 0,
 selectedVarient: selectedItem?.selectedVarient,
 mealVarientUpcharge: selectedItem?.selectedVarient == nil ? 0 : itemPrice ?? 0,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 selectedBoxItems: self.selectedItem?.selectedBoxItem,
 itemType: itemData.itemType,
 isRecursiveSubItemForCombo: false,
 recursiveDataFromEntityGroupID: nil)

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 tempData[editedSubItemIndex] = .subItem(shrEntity)

 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 comboItemSelectioCompletion?(self.comboObj!)

 self.navigationController?.popViewController(animated: false)

 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }
 else {
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .addToCartWithoutLogin) { isSuccess in
 self.view.alpha = 1
 Global.setLoginAsRoot()
 }

 }
 break
 case .forMealRootCustomiserChange(_):
 let latestData = MealParentData(Id: itemData.id, arrCustomise: selectedItem?.selectedCustomiser, strMealId: mealModificationData?.strMealId, Quentity: self.mealModificationData?.Quentity, PricePerItem: pricePerItem, Price: Double(self.mealModificationData?.Quentity ?? 0) * pricePerItem, MealSubItem: self.mealModificationData?.MealSubItem, selectedVarient: self.selectedItem?.selectedVarient, selectedDressingDipping: selectedItem?.selectedDressingDipping, mealObj: self.mealModificationData?.mealObj)
 mealItemSelectionCompletion?(latestData)

 case .forCartAddFromLoyalityWithBooster(let boosterData):
 let validDealByDate = Global.isCurrentDateBetween(startDate: boosterData.startDate, endDate: boosterData.endDate)

 let validDealByTime = Global.isCurrentTimeBetween(startTime: boosterData.displayStartTime, endTime: boosterData.displayEndTime)

 if validDealByDate && validDealByTime{
 let result = CartModule().checkBoosterAlreadyInCart()
 if !result{
 _progressBar.showProgressBar(uiView: self.view)
 CartModule().callCheckDeviceAtCurrentMenu { [weak self] obj in
 guard let self = self else{return}
 DispatchQueue.main.async {
 _progressBar.hideProgressBar(uiView: self.view)
 }

 if let obj = obj{
 if obj.order_accept{
 var cartObj = self.getCartObject()
 cartObj.boosterData = boosterData
 cartObj.boosterId = boosterData.id
 cartObj.quantity = 1
 cartObj.price = cartObj.per_item_price
 sender.isEnabled = false
 CartModule().addToCart(entity: self.itemData, objAddCart: cartObj, actionType: .pointBoosterOnItem, forVC: self) { result in
 sender.isEnabled = true
 if result == true{
 //                                    self.showAlert(errorMessage: "Added to cart") {
 //                                    }
 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) while updating cart") {
 }
 }
 self.navigationController?.popToRootViewController(animated: true)
 }
 }else{
 self.showAlert(errorMessage: obj.message ?? Global.alertMessageSomethingWentWrong) {
 }
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) while checking device time") {
 }
 }
 }
 }else{
 self.showAlert(errorMessage: "Booster already present in cart, at time you can apply only one booster for cart.", completion: nil)
 }

 }else{
 self.showAlert(errorMessage: "Currently booster not available.", completion: nil)
 }

 case .forCartAddFromLoyalityWithOffers(_),.forEditOfferItemCustomiser(_, _, _),.forChangeOfferItem(_, _, _):

 sender.isEnabled = false
 handleSelectedItemForOfferEntity()
 sender.isEnabled = true

 break
 case .editBoosterItem(let cartData):
 let cartObj = getCartObject()
 CartModule().updateCartEntityItemMods(cartObj: cartData, objAddCart: cartObj, actionType: .pointBoosterOnItem, forVC: self){ result in
 if !result{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) wrong while updating cart") {
 }
 }
 self.editCartEntityCompletion?()
 self.navigationController?.popViewController(animated: true)
 }
 case .forComboAddFromReviewScreen:
 self.addSubItemToComboDataForComboSubItem_ADD_FROMREVIEW()
 break
 }
 }
 else {
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .addToCartWithoutLogin) { isSuccess in
 self.view.alpha = 1
 Global.setLoginAsRoot()
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
 vc.loginType = .fromDeails
 self.navigationController?.pushViewController(vc, animated: true)
 }
 }

 }
 @objc private func getOfferMealSelectedData(_ notification:Notification){
 if let mealData = notification.object as? MealParentData{
 print("Success Data")
 DispatchQueue.main.async {
 self.mealModificationData = mealData
 self.handleSelectedItemForOfferEntity()
 self.removeObserverForOfferMealSelection()
 }
 }
 }
 private func addObserverForOfferMealSelection(){
 _notificationCenter.addObserver(self, selector: #selector(getOfferMealSelectedData(_:)), name: .offerMealSelected, object: nil)
 }
 private func removeObserverForOfferMealSelection(){
 _notificationCenter.removeObserver(self, name: .offerMealSelected, object: nil)
 }
 private func pushToMealBundleList(withScreenType:screenModeMealBundleList){
 MenuModule().getMealItemFromMakeItMeal(strMealId: itemData.meals?.first?.meal ?? "") { [weak self]  mealBundlelistData,errMsg in
 guard let self = self else{return}
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 if mealBundlelistData?.count ?? 0 > 0 {

 self.setMealData()
 var tempArray = [MealBundleSubEntityData]()
 _ = mealBundlelistData?.first?.bundles?.map({ bundle in
 tempArray.append(MealBundleSubEntityData(strMealId: self.mealModificationData?.strMealId,
 strSelectedEntityId: nil,        strSelectedBundleEntityID:  nil,
 parentBundleId: bundle.id,
 arrEntityCustomise: nil,
 itemTitle: bundle.name ?? "",
 Quentity: self.mealModificationData?.Quentity,
 PricePerItem: nil,
 Price: nil,
 baseItemPrice: 0,
 selectedVarient: nil, mealVarientUpcharge: 0,
 selectedDressingDipping: nil,
 itemType: nil))
 })
 self.mealModificationData?.MealSubItem = tempArray
 self.mealModificationData?.allowedQuantityForOffer = self.thStepper?.getMaxValue()

 let storyBoard = Global.singleton.getStoryboard(storyBoardName: .meal)
 let vc = storyBoard.instantiateViewController(withIdentifier: "MealBundleListController") as! MealBundleListController

 vc.screenType = withScreenType

 vc.mealModificationData = self.mealModificationData
 vc.rootItems = self.itemData
 vc.arrMealBundle = mealBundlelistData?.first?.bundles ?? []
 self.navigationController?.show(vc, sender: nil)
 }
 }
 }
 private func pushToMealBundleList(){

 switch itemDetailScreenType {
 case .forCartAdd:

 self.pushToMealBundleList(withScreenType: .newMealSelection)

 case .forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _):

 self.pushToMealBundleList(withScreenType: .newOfferMealSelection)
 addObserverForOfferMealSelection()

 case .forEditOfferItemCustomiser(_, _, _):
 self.navigationController?.popViewController(animated: true)
 break
 default:
 break
 }
 }

 private func gotoSelectMealForCombo(recursiveData:ComboSelectedItemRecursiveData?){
 var recursiveEntityParentGroupId = ""
 if recursiveData != nil{
 recursiveEntityParentGroupId = recursiveData!.entityGroupId
 }
 MenuModule().getMealItemFromMakeItMeal(strMealId: itemData.meals?.first?.meal ?? "") { [weak self]  mealBundlelistData,errMsg in
 guard let self = self else{return}
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 if mealBundlelistData?.count ?? 0 > 0 {

 self.setMealData()
 var tempArray = [MealBundleSubEntityData]()
 mealBundlelistData?.first?.bundles?.map({ bundle in
 tempArray.append(MealBundleSubEntityData(strMealId: self.mealModificationData?.strMealId,
 strSelectedEntityId: nil,        strSelectedBundleEntityID:  nil,
 parentBundleId: bundle.id,
 arrEntityCustomise: nil,
 itemTitle: bundle.name ?? "",
 Quentity: self.mealModificationData?.Quentity,
 PricePerItem: nil,
 Price: nil,
 baseItemPrice: 0,
 selectedVarient: nil, mealVarientUpcharge: 0,
 selectedDressingDipping: nil,
 itemType: nil))
 })
 self.mealModificationData?.comboBundle = self.mealItem
 self.mealModificationData?.comboBaseBundleEntityID = self.itemData.parentComboBundleEntityId
 self.mealModificationData?.isRecursiveSubItemForCombo = !recursiveEntityParentGroupId.isEmpty
 self.mealModificationData?.recursive_data_from_EntityGroupID = recursiveEntityParentGroupId.isEmpty ? nil : recursiveEntityParentGroupId
 self.mealModificationData?.MealSubItem = tempArray

 let storyBoard = Global.singleton.getStoryboard(storyBoardName: .meal)
 let vc = storyBoard.instantiateViewController(withIdentifier: "MealBundleListController") as! MealBundleListController
 vc.mealModificationData = self.mealModificationData
 vc.rootItems = self.itemData
 vc.screenType = .newComboMealSelection
 vc.arrMealBundle = mealBundlelistData?.first?.bundles ?? []
 self.navigationController?.show(vc, sender: nil)
 }
 }
 }

 @IBAction func btnMakeItMeal(_ sender: UIButton) {
 sender.disableFor()
 switch itemType{

 case .onlyVarient:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.showAlert(errorMessage: "Please select one of the varient first for order", completion: nil)
 return
 }
 break

 case .mandatoryCustomiser:
 if selectedItem?.mandatoryCustomiser != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser) ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 //                    self.view.alpha = 0.5
 //                    self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                        self.view.alpha = 1.0
 //                        self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                    }
 //                    self.showAlert(errorMessage: "You have not selected all mandatory customiser..") {
 //                    }
 return
 }

 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return
 }
 break
 case .mandatoryDressingDipping:
 if selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire  = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping) ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 //                    self.showAlert(errorMessage: "You have not selected all mandatory dressing or dipping..") {
 //                    }
 return
 }
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return
 }
 break
 case .mandatoryCustmDressDipp:
 if selectedItem?.mandatoryCustomiser != nil && selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)  ?? [Customize]()).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})

 let selectedModifireOther = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem!.selectedDressingDipping) ?? [Customize]()).compactMap({$0.id})

 let mandatoryModifireOther = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})
 //                if (selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:))) && (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))) {
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)){
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 return
 }else if (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))) {
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifireOther){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 return
 }

 //                    self.view.alpha = 0.5
 //                    self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                        self.view.alpha = 1.0
 //                        self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                        //self.pushToDippingDressingScreen(arrCustomise: <#T##[Customize]#>)
 //                    }
 //                    self.showAlert(errorMessage: "You have not selected all mandatory customiser..") {
 //                    }
 //                    return
 //                }

 //                    if selectedModifire != mandatoryModifire && selectedModifireOther != mandatoryModifireOther {
 //                        self.showAlert(errorMessage: "You have not selected all mandatory customiser and dressing dipping..") {
 //
 //                        }
 //                        return
 //                    }
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return
 }
 case .multibox:
 break
 case .none:
 break
 case .varientMandatoryCustomiser:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }

 return
 }
 if selectedItem?.mandatoryCustomiser != nil{
 let selectedModifire = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)!).compactMap({$0.id}) //selectedItem!.selectedCustomiser?.compactMap({$0.id}).sorted(by: {$0 > $1}) ?? []
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 //                    self.view.alpha = 0.5
 //                    self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                        self.view.alpha = 1
 //                        self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                    }

 return
 }
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 return
 }
 case .varientMandatoryDressingDipping:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }

 return
 }
 if selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire =  self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping)!).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})

 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)) {
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 //                    self.view.alpha = 0.5
 //                    self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                        self.view.alpha = 1
 //                        self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                    }
 return
 }

 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }

 return

 }
 case .varientMandatoryCustmDressDipp:
 if selectedItem?.varientData != nil && selectedItem?.selectedVarient == nil{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .variantMandatory) { isSuccess in
 self.view.alpha = 1
 }
 return
 }else if selectedItem?.mandatoryCustomiser != nil && selectedItem?.mandatoryDressingDipping != nil{
 let selectedModifire =
 self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedCustomiser)!).compactMap({$0.id})
 let mandatoryModifire = selectedItem!.mandatoryCustomiser!.compactMap({$0.id}).sorted(by: {$0 > $1})

 let selectedModifireOther = self.selectedMinimumModifirelist(inputCustomizer: (selectedItem?.selectedDressingDipping)!).compactMap({$0.id})
 let mandatoryModifireOther = selectedItem!.mandatoryDressingDipping!.compactMap({$0.id}).sorted(by: {$0 > $1})

 //                if (selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:))) && (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))) {
 if selectedModifire.isEmpty || !mandatoryModifire.allSatisfy(selectedModifire.contains(_:)){
 self.getNameofMandatoryCustomiser(selectedModifire: selectedModifire){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 return
 }else if (selectedModifireOther.isEmpty || !mandatoryModifireOther.allSatisfy(selectedModifireOther.contains(_:))){
 self.getNameofMandatoryDressingDipping(selectedModifire: selectedModifireOther){[weak self] in
 guard let self = self else {return}
 self.btnMakeItMeal(sender)
 }
 return
 }
 //                    self.view.alpha = 0.5
 //                    self.showThemeAlertVC(type: .mandatoryCustomizer) { isSuccess in
 //                        self.view.alpha = 1
 //                        self.btnCustomNavigationClick(self.btnCustmise)
 //
 //                    }
 //                    return
 //                }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 return
 }
 }
 let accessToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
 if !accessToken.isEmpty {
 switch itemDetailScreenType {
 case .forCartAdd,.forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _):

 pushToMealBundleList()

 case .forCartAddFromLoyalityWithBooster(_):
 break
 /*
  case .forComboMealAdd:
  MenuModule().getMealItemFromMakeItMeal(strMealId: itemData.meals?.first?.meal ?? "") { [weak self]  mealBundlelistData,errMsg in
  guard let self = self else{return}
  if !errMsg.isEmpty{
  self.showAlert(errorMessage: errMsg)
  return
  }
  if mealBundlelistData?.count ?? 0 > 0 {

  self.setMealData()
  var tempArray = [MealBundleSubEntityData]()
  mealBundlelistData?.first?.bundles?.map({ bundle in
  tempArray.append(MealBundleSubEntityData(strMealId: self.mealModificationData?.strMealId,
  strSelectedEntityId: nil,        strSelectedBundleEntityID:  nil,
  parentBundleId: bundle.id,
  arrEntityCustomise: nil,
  itemTitle: bundle.name ?? "",
  Quentity: self.mealModificationData?.Quentity,
  PricePerItem: nil,
  Price: nil,
  selectedVarient: nil, mealVarientUpcharge: 0,
  selectedDressingDipping: nil,
  itemType: nil))
  })
  self.mealModificationData?.comboBundle = self.mealItem
  self.mealModificationData?.MealSubItem = tempArray

  let storyBoard = Global.singleton.getStoryboard(storyBoardName: .meal)
  let vc = storyBoard.instantiateViewController(withIdentifier: "MealBundleListController") as! MealBundleListController
  vc.mealModificationData = self.mealModificationData
  vc.rootItems = self.itemData
  vc.screenType = .newComboMealSelection

  vc.arrMealBundle = mealBundlelistData?.first?.bundles ?? []



  vc.arrMealBundle = mealBundlelistData?.first?.bundles ?? []
  self.navigationController?.show(vc, sender: nil)
  }
  }
  break
  */
 case .forComboMealAdd,.forComboAddFromReviewScreen:
 gotoSelectMealForCombo(recursiveData: nil)
 case .forComboRecusiveItemSelection(let data):
 gotoSelectMealForCombo(recursiveData: data)


 case .editCartItem(let cartData),.editBoosterItem(let cartData):
 // REMOVE ITEM FROM CART ACTION
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .removeItemFromCart) { [weak self] result in
 guard let self = self else{return}
 self.view.alpha = 1
 if result{
 self.updateCartItem(cartData: cartData)
 }
 }
 case .forMealItemSelection:

 let storyBoard = Global.singleton.getStoryboard(storyBoardName: .meal)
 let vc = storyBoard.instantiateViewController(withIdentifier: "MealBundleListController") as! MealBundleListController
 //        if itemData.meals?.count ?? 0 > 0 {
 //            vc.strMealId = itemData.meals?[0].meal ?? ""
 //        }
 //            vc.mealSharObj = itemData.meals?[0]
 vc.mealModificationData = self.mealModificationData
 vc.rootItems = itemData
 vc.screenType = .newMealSelection
 let itemPrice : Double = 0.0
 if selectedItem?.selectedVarient == nil{
 self.setUpdatedPrice()
 }else{
 setUpdatedPrice()
 }

 MenuModule().getMealItemFromMakeItMeal(strMealId: itemData.meals?.first?.meal ?? "") { mealBundlelistData,errMsg in
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 if mealBundlelistData?.count ?? 0 > 0 {
 _ = mealBundlelistData?.first
 self.navigationController?.show(vc, sender: nil)
 }
 }

 break
 case .forComboItemSelection:
 break
 case .forMealEditCustomiser(let subEntityData):
 // CANCEL EVENT
 if let curentBundleIndex = mealModificationData?.MealSubItem?.firstIndex(where: {$0.parentBundleId == subEntityData.parentBundleId}){
 mealModificationData?.MealSubItem?[curentBundleIndex] = subEntityData
 mealItemSelectionCompletion?(mealModificationData!)

 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong, completion: nil)
 }

 break
 case .forComboEditSubItemCustomiser(let subEntityData,let editedSubItemIndex):
 // CANCEL EVENT

 let subItems = comboObj?.arrComboBundleItems ?? []
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let entity = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 tempData[editedSubItemIndex] = .subItem(subEntityData)

 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 comboItemSelectioCompletion?(self.comboObj!)

 self.navigationController?.popViewController(animated: false)

 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 break
 case .forMealRootCustomiserChange(_):
 cancelTapped?()
 case .forMealItemChange,.forComboItemChange(_):
 cancelTapped?()
 }
 }
 else {
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .addToMealWithoutLogin) { isSuccess in
 self.view.alpha = 1
 Global.setLoginAsRoot()
 }
 }

 }

 @IBAction func btnFavouriteClick(_ sender: UIButton) {

 if sender.isSelected {
 // UNFAVOURITE ITEM\
 if !self.checkLoginOtherWiseShowfavItemValidation(){
 return
 }
 MenuModule.updateFavouriteItem(itemId: self.itemData.id ?? "", isFavourite: false) { Error in
 if let error = Error{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 }else{
 Tbl_Menu_Item_List.updateFavouriteItem(isFavourite: false, itemId: self.itemData.id ?? "", context: _coreDataShared.getContext(), completion: nil)
 sender.isSelected = false
 }
 }

 }
 else {
 // FAVOURITE ITEM
 if !self.checkLoginOtherWiseShowfavItemValidation(){
 return
 }
 MenuModule.updateFavouriteItem(itemId: self.itemData.id ?? "", isFavourite: true) { Error in
 if let error = Error{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 }else{
 Tbl_Menu_Item_List.updateFavouriteItem(isFavourite: true, itemId: self.itemData.id ?? "", context: _coreDataShared.getContext(), completion: nil)
 sender.isSelected = true
 }
 }
 }

 }

 @objc func didStepperValueChanged() {
 print("latest value: \(thStepper!.value)")
 setUpdatedPrice()
 }

 func getNameofMandatoryCustomiser(selectedModifire :[String],completion:(()->())?) {
 var itemTitle = ""
 let itemName = selectedItem?.mandatoryCustomiser?.first(where: {$0.id != (selectedModifire.map({$0}).first)})
 itemTitle = itemName?.modifierCategory ?? ""
 //print(itemName?.modifierCategory)
 //                        selectedItem?.mandatoryCustomiser?.forEach({ custObj in
 //                            selectedModifire.forEach { strName in
 //                                //itemTitle = ""
 //                                if custObj.id != strName {
 //                                    itemTitle += custObj.modifierCategory ?? ""
 //                                    return
 //                                }
 //                            }
 //                            if itemTitle != "" {
 //                                return
 //                            }
 //
 //                        })
 self.view.alpha = 0.5
 let titleOfMessage = "\(itemTitle)"
 let strMessage = "You have missed customisation \(itemTitle) select to proceed!"
 self.showThemeAlertVC(type: .mandatoryCustomizerWithtitle(title: titleOfMessage, msg: strMessage)) { isSuccess in
 self.view.alpha = 1
 self.modifireFlow(itemData1: self.selectedItem!){
 completion?()
 }
 }
 }
 func getNameofMandatoryDressingDipping(selectedModifire :[String],completion:(()->())?) {
 var itemTitle = ""
 let itemName = selectedItem?.mandatoryDressingDipping?.first(where: {$0.id != (selectedModifire.map({$0}).first)})
 itemTitle = itemName?.modifierCategory ?? ""
 //print(itemName?.modifierCategory)
 //                        selectedItem?.mandatoryCustomiser?.forEach({ custObj in
 //                            selectedModifire.forEach { strName in
 //                                //itemTitle = ""
 //                                if custObj.id != strName {
 //                                    itemTitle += custObj.modifierCategory ?? ""
 //                                    return
 //                                }
 //                            }
 //                            if itemTitle != "" {
 //                                return
 //                            }
 //
 //                        })
 self.view.alpha = 0.5
 let titleOfMessage = "\(itemTitle)"
 let strMessage = "You have missed selecting a \(itemTitle) please choose to proceed"
 self.showThemeAlertVC(type: .mandatoryCustomizerWithtitle(title: titleOfMessage, msg: strMessage)) { isSuccess in
 self.view.alpha = 1
 self.pushToDippingDressingScreen {
 completion?()
 }
 }
 }
 //MARK: - View LifeCycle

 override func viewDidLoad() {
 super.viewDidLoad()
 //self.view.addSubview(thStepper)
 //self.getUnAvailableModifire()

 let whiteColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
 imgItem.image = UIImage(named: "Logo")
 //thStepper = THStepper(viewData: .init(color: whiteColor, minimum: 1, maximum: itemData!.maxQuantity! == 0 ? Double(.max) : Double(itemData!.maxQuantity!), stepValue: 1, style: .forVarient))
 thStepper = THStepper(viewData: .init(color: whiteColor, minimum: 1, maximum: 10000, stepValue: 1, style: .forVarient))
 thStepper!.translatesAutoresizingMaskIntoConstraints = false
 thStepper!.addTarget(self, action: #selector(didStepperValueChanged), for:  .valueChanged)
 self.viewStepper.addSubview(thStepper!)

 NSLayoutConstraint.activate([
 thStepper!.widthAnchor.constraint(equalToConstant: 100),
 thStepper!.heightAnchor.constraint(equalToConstant: 50)
 ])
 thStepper!.layer.cornerRadius = 5
 var cartItemQuantity = 1
 switch itemDetailScreenType {
 case .forCartAdd,.forCartAddFromLoyalityWithBooster(_):
 thStepper?.setValue(Double(cartItemQuantity))
 break
 case .forMealRootCustomiserChange(_):
 cartItemQuantity = mealModificationData?.Quentity ?? 1
 thStepper?.setValue(Double(cartItemQuantity))
 break
 case .editCartItem(let cartData),.editBoosterItem(let cartData):
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = cartData.quantity
 thStepper?.setValue(Double(cartItemQuantity))
 selectedItem?.selectedBoxItem = cartData.boxItems

 case .forMealItemSelection:
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = mealModificationData?.Quentity ?? 1
 thStepper?.setValue(Double(cartItemQuantity))
 break
 case .forMealEditCustomiser(_):
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = mealModificationData?.Quentity ?? 1
 thStepper?.setValue(Double(cartItemQuantity))

 case .forMealItemChange:
 cartItemQuantity = mealModificationData?.Quentity ?? 1
 thStepper?.setValue(Double(cartItemQuantity))
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)

 case .forComboItemChange(_),.forComboItemSelection,.forComboMealAdd:
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = comboObj?.Quentity ?? 1
 thStepper?.updateMinMax(minimum: 1, maximum: Double(mealItem?.allowedQuantityCombo ?? 1))
 case .forComboEditSubItemCustomiser(let subItem,_):
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = subItem.Quentity ?? 0
 thStepper?.updateMinMax(minimum: Double(mealItem?.allowedQuantityCombo ?? 1), maximum: Double(mealItem?.allowedQuantityCombo ?? 1))

 case .forCartAddFromLoyalityWithOffers(let offerData):

 if let itemFrom = offerData.getOfferItemEntityGroup(itemData: itemData){
 switch itemFrom{
 case .rule(let entityGroup):
 self.isRunAsMealAction = entityGroup.action_type == .meal
 if (entityGroup.allowed_quantity ?? 0) > 0{
 let minQuantity = 1 //min(entityGroup.allowed_quantity ?? 1,1)
 let maxQuantity = entityGroup.allowed_quantity ?? 1
 thStepper?.updateMinMax(minimum: Double(minQuantity), maximum: Double(maxQuantity))
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong){
 self.navigationController?.popViewController(animated: true)
 }
 }
 case .apply(let entityGroup):
 self.isRunAsMealAction = entityGroup.action_type == .meal
 if (entityGroup.allowed_quantity ?? 0) > 0{
 let minQuantity = 1//min(entityGroup.allowed_quantity ?? 1,1)
 let maxQuantity = entityGroup.allowed_quantity ?? 1
 thStepper?.updateMinMax(minimum: Double(minQuantity), maximum: Double(maxQuantity))
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong){
 self.navigationController?.popViewController(animated: true)
 }
 }
 }
 }
 break
 case .forEditOfferItemCustomiser(let offerData,let offerSubItem, let editedIndex),.forChangeOfferItem(let offerData,let offerSubItem,let editedIndex):
 if let itemFrom = offerData.getOfferItemEntityGroup(fromOfferSelectedItems: offerSubItem){

 let cartEditedQuantity = offerSubItem.arrOfferItems?[editedIndex].quantity

 var allowed_quantity = cartEditedQuantity ?? 0

 switch itemFrom{
 case .rule(let entityGroup):

 self.isRunAsMealAction = entityGroup.action_type == .meal
 allowed_quantity += (entityGroup.allowed_quantity ?? 0)
 if (allowed_quantity) > 0{
 let minQuantity = 1//min(entityGroup.allowed_quantity ?? 1,1)
 let maxQuantity = allowed_quantity
 thStepper?.updateMinMax(minimum: Double(minQuantity), maximum: Double(maxQuantity))
 thStepper?.resetValue()
 thStepper?.setValue(Double(cartEditedQuantity ?? minQuantity))
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong){
 self.navigationController?.popViewController(animated: true)
 }
 }
 case .apply(let entityGroup):
 self.isRunAsMealAction = entityGroup.action_type == .meal
 allowed_quantity += (entityGroup.allowed_quantity ?? 0)
 if (allowed_quantity) > 0{
 let minQuantity = 1//min(entityGroup.allowed_quantity ?? 1,1)
 let maxQuantity = allowed_quantity
 thStepper?.updateMinMax(minimum: Double(minQuantity), maximum: Double(maxQuantity))

 thStepper?.resetValue()
 thStepper?.setValue(Double(cartEditedQuantity ?? minQuantity))
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong){
 self.navigationController?.popViewController(animated: true)
 }
 }
 }
 }
 case .forComboRecusiveItemSelection(let data):
 thStepper?.updateMinMax(minimum: 1, maximum: Double(data.allowedRecursiveQuantityCombo ?? 0))
 break
 case .forComboAddFromReviewScreen:
 btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)
 cartItemQuantity = comboObj?.Quentity ?? 1
 thStepper?.updateMinMax(minimum: 1, maximum: Double(mealItem?.allowedQuantityCombo ?? 1))
 break
 }

 // Do any additional setup after loading the view.
 self.viewMealItmes.isHidden = true
 lblSelectedItemList.text = ""
 self.viewSize.isHidden   = true

 self.colletionVarient.register(UINib(nibName: CollCellVarient.identifible, bundle: nil), forCellWithReuseIdentifier: CollCellVarient.identifible)
 self.colletionVarient.delegate   = self
 self.colletionVarient.dataSource = self

 self.tblMealItems.register(UINib(nibName: CellDressingDeeping.identifire, bundle: nil), forCellReuseIdentifier: CellDressingDeeping.identifire)
 self.tblMealItems.delegate   = self
 self.tblMealItems.dataSource = self
 self.btnCustmise.layer.borderColor = ThemeColors.titleGryColorRBI.getColor.cgColor
 self.btnCustmise.layer.cornerRadius = 5
 self.btnCustmise.backgroundColor = ThemeColors.white.getColor
 self.btnCustmise.setTitleColor(ThemeColors.titleGryColorRBI.getColor, for: .selected)


 let lblInfoAttribute: [NSAttributedString.Key: Any] = [
 .font: UIFont.systemFont(ofSize: 14),
 .foregroundColor: ThemeColors.link.getColor,
 .underlineStyle: NSUnderlineStyle.single.rawValue
 ] // .double.rawValue, .thick.rawValue

 let attributeString = NSMutableAttributedString(
 string: "Nutrition & Allergen Info",
 attributes: lblInfoAttribute
 )
 btnNutritionInfo.setAttributedTitle(attributeString, for: .normal)
 btnNutritionInfo.leftImage(image: UIImage(named: "btnInfo")!, renderMode: .alwaysTemplate)
 btnNutritionInfo.contentMode = .center
 //btnNutritionInfo.titleLabel?.textAlignment = .center
 imgItem.contentMode = .scaleAspectFit
 lblNuturation.text = EnumNoDataText.nutrationInformation.rawValue
 lblNuturation.textAlignment = .center
 // btnClose.setImage(UIImage(named: "btnBackArrow.png"), for: .normal)

 btnFavourite.setImage(UIImage(named: "starSelected"), for: .selected)
 btnFavourite.setImage(UIImage(named: "starUnSelected"), for: .normal)
 setUIAccordingScreenType()
 getData()
 setNutritionBtnVisiblity()
 // setCustomizedItemPriceAtInit()
 // FirebaseAnalytics.Analytics.logEvent(AnalyticsEventViewItem, parameters: ["ItemTitle" : itemData.title ?? "", "ItemName" : itemData.name ?? ""])

 }

 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 self.tabBarController?.tabBar.isHidden = true
 imgItem.isHidden = false
 switch itemDetailScreenType {
 case .forCartAdd,.editCartItem (_), .forMealItemSelection ,.forCartAddFromLoyalityWithBooster(_),.editBoosterItem(_),.forCartAddFromLoyalityWithOffers(_),.forComboMealAdd,.forComboRecusiveItemSelection(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _):
 itemData.image != nil ? (imgItem.imageURL(itemData.image!)) : (imgItem.image = nil)
 //strSelectedDressingDipping = ""
 setCustomizedItemPrice()

 case .forMealEditCustomiser(_),.forComboEditSubItemCustomiser(_):
 //Dispaly Stored ItemData
 // Get BundleId and based on that get item you want to Edit..
 itemData.image != nil ? (imgItem.imageURL(itemData.image!)) : (imgItem.image = nil)
 strSelectedDressingDipping = ""
 setCustomizedItemPrice()
 break
 case .forMealRootCustomiserChange(let parentData):
 let itemData = Tbl_Menu_Item_List.getRecords(id: parentData.Id ?? "", in: _coreDataShared.getContext())
 if itemData?.count ?? 0 > 0 {
 //self.itemData = itemData?.first
 //                showItemDetailsForMeal(itemData: self.itemData, varientType: parentData.selectedVarient?.id ?? "", bundleItem: mealItem!)
 }
 self.itemData.image != nil ? (imgItem.imageURL(self.itemData.image!)) : (imgItem.image = nil)
 strSelectedDressingDipping = ""
 setCustomizedItemPrice()

 case .forMealItemChange,.forComboItemChange(_),.forComboItemSelection:
 itemData.image != nil ? (imgItem.imageURL(itemData.image!)) : (imgItem.image = nil)
 strSelectedDressingDipping = ""
 setCustomizedItemPrice()
 case .forComboAddFromReviewScreen:
 strSelectedDressingDipping = ""
 setCustomizedItemPrice()
 break
 }

 btnFavourite.isSelected = false
 if let record = Tbl_Menu_Item_List.getRecords(id: itemData.id ?? "", in: _coreDataShared.getContext())?.first{
 btnFavourite.isSelected = record.is_favourite
 }
 }

 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 self.tabBarController?.tabBar.isHidden = false
 }

 //MARK: - Custom Methods
 private func checkOfferEntityGroups(attachment:Attachment,arrayGroups:[(entityIds: [String],entityGroupFrom:ItemListOfferEntityGroupType, entityType: EnumEntityType?, action_type:EnumActionType, variant:[String], isExecuted: Bool)],completion:((Attachment?)->())?){

 var attachmentObj = attachment

 var arrayEntityGroups = arrayGroups

 if let groupToBeCheck = arrayEntityGroups.firstIndex(where: {$0.isExecuted == false}){

 if (arrayEntityGroups[groupToBeCheck].variant).isEmpty || (arrayEntityGroups[groupToBeCheck].variant.contains(self.selectedItem?.selectedVarient?.variantType ?? "")){

 LoyaltyModule().getValidItemListfromRuleAndApplyInEntityGroupNew(attachmentFromItemId: self.itemData.id ?? "", entityIds: arrayEntityGroups[groupToBeCheck].entityIds , entityType:  arrayEntityGroups[groupToBeCheck].entityType, action_type: arrayEntityGroups[groupToBeCheck].action_type, variant: arrayEntityGroups[groupToBeCheck].variant, isIgnoreRootDispaly: true) { result in

 if result{
 // CHECK FOR VARIANT
 if self.selectedItem?.selectedVarient != nil && !arrayEntityGroups[groupToBeCheck].variant.isEmpty{

 let itemVariant = self.itemData.variants?.filter({arrayEntityGroups[groupToBeCheck].variant.contains($0.variantType ?? "")})

 let hasSelctedVariant = itemVariant?.contains(where: {$0.variantType == self.selectedItem?.selectedVarient?.variantType}) ?? false



 if hasSelctedVariant{
 attachmentObj.offerEntityGroupFrom = arrayEntityGroups[groupToBeCheck].entityGroupFrom
 completion?(attachmentObj)
 }else{
 // VARIANT NOT FOUND CHECK FOR NEXT GROUP
 arrayEntityGroups[groupToBeCheck].isExecuted = true
 self.checkOfferEntityGroups(attachment: attachment, arrayGroups: arrayEntityGroups, completion: completion)
 }
 }else{
 // ITEM HAS NOT VARIANT
 attachmentObj.offerEntityGroupFrom = arrayEntityGroups[groupToBeCheck].entityGroupFrom
 completion?(attachmentObj)
 }

 }else{
 // ITEM NOT FOUND CHECK FOR NEXT GROUP
 arrayEntityGroups[groupToBeCheck].isExecuted = true
 self.checkOfferEntityGroups(attachment: attachment, arrayGroups: arrayEntityGroups, completion: completion)
 }
 }
 }
 else{
 // VARIANT NOT FOUND CHECK FOR NEXT GROUP
 arrayEntityGroups[groupToBeCheck].isExecuted = true
 self.checkOfferEntityGroups(attachment: attachment, arrayGroups: arrayEntityGroups, completion: completion)
 }
 }else{
 // ALL GROUPS EXECUTED ITEM DOESNT FOUND
 completion?(nil)
 }
 }
 private func getOfferAttachmentOnVariants(attachment:Attachment ,completion:((Attachment?)->())?){

 _progressBar.showProgressBar(uiView: self.view)
 LoyaltyModule().getOffersData { arrOffers, error in
 _progressBar.hideProgressBar(uiView: self.view)

 if error == nil {
 if let offerData =  arrOffers?.first(where: {$0._id == attachment.entity}){

 let result =  LoyaltyModule().validateOfferDataForDateValidation(offerModel: offerData)

 if result{
 var arrayEntityGroups:[(entityIds: [String],entityGroupFrom:ItemListOfferEntityGroupType,entityType: EnumEntityType?, action_type:EnumActionType, variant:[String], isExecuted: Bool)] = []

 if offerData.discount_apply?.type == EnumDiscountApplyOn.entity.rawValue{

 _ = offerData.discount_apply?.entity_groups?.map({ entityGroup in

 arrayEntityGroups.append((entityIds: entityGroup.entity ?? [],entityGroupFrom:ItemListOfferEntityGroupType(itemFrom: .apply, entity_group_id: entityGroup.id),entityType: EnumEntityType(rawValue: entityGroup.entity_type ?? ""), action_type: entityGroup.action_type ?? .item, variant: entityGroup.variant ?? [], isExecuted: false))

 })
 }

 if offerData.discount_rule?.entity_check == true{

 _ = offerData.discount_rule?.entity_groups?.map({ entityGroup in

 arrayEntityGroups.append((entityIds: entityGroup.entity ?? [],entityGroupFrom:ItemListOfferEntityGroupType(itemFrom: .rule, entity_group_id: entityGroup._id), entityType: EnumEntityType(rawValue: entityGroup.entity_type ?? ""), action_type: entityGroup.action_type ?? .item, variant: entityGroup.variant ?? [], isExecuted: false))

 })
 }

 self.checkOfferEntityGroups(attachment: attachment, arrayGroups: arrayEntityGroups,completion: completion)
 }

 }else{
 completion?(nil)
 }
 }
 }
 }
 private func getAttachmentOnVariants(attachments:[Attachment],completion:(([Attachment])->())?){
 let myGroup = DispatchGroup()

 var attachmentsOnVariants = [Attachment]()
 if !self.isCancleAttachment {
 if attachments.count > 0 {

 _ = attachments.map { attachment in

 if attachment.attachmentType == .meal{
 myGroup.enter()
 MenuModule().getMealItemFromMakeItMeal(strMealId: attachment.entity ?? "") { [weak self]  arrMealData,errMsg in
 myGroup.leave()
 guard let self = self else{return}
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 myGroup.enter()
 MenuModule().getComboEntityDetails(arrMealData?.first?.bundles?.first?.entity ?? [], mealID: attachment.entity ?? "" , isIgnoreRootDisplay: true) {
 arrItemList, msg in

 if let itemData =  arrItemList?.first(where: {$0.id == self.itemData.id}){
 if let entity = arrMealData?.first?.bundles?.first?.entity?.first(where: {$0.id == itemData.parentComboBundleEntityId}){

 if (entity.variantType ?? []).isEmpty{
 attachmentsOnVariants.append(attachment)
 }else{
 let result = entity.variantType!.contains(self.selectedItem?.selectedVarient?.variantType ?? "")
 if result{
 attachmentsOnVariants.append(attachment)
 }
 }
 }
 }
 myGroup.leave()
 }
 }
 }
 else if attachment.attachmentType == .promotion {

 myGroup.enter()

 self.getOfferAttachmentOnVariants(attachment: attachment) { attachmentData in

 myGroup.leave()

 if let attachmentData = attachmentData{
 attachmentsOnVariants.append(attachmentData)
 }

 }
 }
 }
 }
 }
 myGroup.notify(queue: DispatchQueue.main, execute: {
 completion?(attachmentsOnVariants)
 })
 }
 private func addSubItemToComboDataForComboSubItem_ADD_CHANGE(editedIndex:Int?){
 let subItems = comboObj?.arrComboBundleItems ?? []
 var recursiveEntityId = ""
 switch itemDetailScreenType {
 case .forComboRecusiveItemSelection(let comboSelectedItemRecursiveData):
 recursiveEntityId = comboSelectedItemRecursiveData.entityGroupId
 default:
 break
 }
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let entity = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 let price = ((entity.applyPrice ?? false) ? entity.price :  itemData.price) ?? 0

 var itemPrice:Double? = Global.getPriceForItem(price: price, mealID: comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? itemData.mealUpchargePrice :  itemData.promotionPrice) ?? [])

 if selectedItem?.selectedVarient != nil{
 if (entity.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 // CHECK VARIENT PRICE

 let varientPrice = ((entity.applyPrice ?? false) ? entity.price :  selectedItem?.selectedVarient?.price) ?? 0

 itemPrice = Global.getPriceForItem(price: varientPrice,mealID: self.comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 }
 }

 // SET BOX ITEMS IF BOX HAS DEFAULT ITEMS
 setBoxItemsDefaultItemsNotChange()

 let shrEntity = MealBundleSubEntityData(strMealId: comboObj?.mealId,
 strSelectedEntityId: itemData.id,
 strSelectedBundleEntityID: itemData.parentComboBundleEntityId,
 parentBundleId: mealItem?.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.getItemName(selectedVariant: selectedItem?.selectedVarient),
 Quentity: Int(thStepper?.value ?? 0),
 PricePerItem: (itemPrice ?? 0),
 Price: (itemPrice ?? 0) * Double(comboObj?.Quentity ?? 0),
 baseItemPrice: itemPrice ?? 0,
 selectedVarient: selectedItem?.selectedVarient,
 mealVarientUpcharge: itemPrice ?? 0,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 selectedBoxItems:self.selectedItem?.selectedBoxItem,
 itemType: itemData.itemType,
 isRecursiveSubItemForCombo:!recursiveEntityId.isEmpty  ,
 recursiveDataFromEntityGroupID: recursiveEntityId .isEmpty ? nil : recursiveEntityId)

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 if editedIndex != nil{
 tempData[editedIndex!] = .subItem(shrEntity)
 }else{
 tempData.append(.subItem(shrEntity))
 }

 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 comboItemSelectioCompletion?(self.comboObj!)

 self.navigationController?.popViewController(animated: false)

 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }
 private func addOfferToComboData_ADD_FROMREVIEW(offerData:OffersModel){
 let subItems = comboObj?.arrComboBundleItems ?? []
 var recursiveEntityId = ""
 switch itemDetailScreenType {
 case .forComboRecusiveItemSelection(let comboSelectedItemRecursiveData):
 recursiveEntityId = comboSelectedItemRecursiveData.entityGroupId
 default:
 break
 }
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let _ = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 var tempOfferData = offerData
 tempOfferData.setAttributedText()
 tempOfferData.comboId = self.comboObj?.mealId
 tempOfferData.comboBundleId = comboObj?.arrComboBundleItems?[currentSubItemIndex].bundleId
 tempOfferData.combo_entity_added_from_group_Id = currentSelectedEntityId
 tempOfferData.combo_recursive_data_from_EntityGroupID = recursiveEntityId
 tempData.append(.offerAsSubItem(tempOfferData))
 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 comboItemSelectioCompletion?(self.comboObj!)

 self.navigationController?.popViewController(animated: false)

 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }
 private func addOfferToComboDataAndStartAttachmentFlow(offerData:OffersModel){
 let subItems = comboObj?.arrComboBundleItems ?? []

 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let _ = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 var tempOfferData = offerData
 tempOfferData.setAttributedText()
 tempOfferData.comboId = self.comboObj?.mealId
 tempOfferData.comboBundleId = comboObj?.arrComboBundleItems?[currentSubItemIndex].bundleId
 tempOfferData.combo_entity_added_from_group_Id = currentSelectedEntityId
 tempOfferData.combo_recursive_data_from_EntityGroupID = ""
 tempData.append(.offerAsSubItem(tempOfferData))
 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 if let currentComboBundle = mealItem,let combodata =   comboObj{
 self.handleCurrentAttachmentBundleItemsAndMoveNextIfSatisfy(currentComboBundle: currentComboBundle, comboData: combodata)

 }
 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }
 private func addSubItemToComboDataForComboSubItem_ADD_FROMREVIEW(){
 let subItems = comboObj?.arrComboBundleItems ?? []
 var recursiveEntityId = ""
 switch itemDetailScreenType {
 case .forComboRecusiveItemSelection(let comboSelectedItemRecursiveData):
 recursiveEntityId = comboSelectedItemRecursiveData.entityGroupId
 default:
 break
 }
 if !subItems.isEmpty{
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

 let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

 if let entity = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

 let price = ((entity.applyPrice ?? false) ? entity.price :  itemData.price) ?? 0

 var itemPrice:Double? = Global.getPriceForItem(price: price, mealID: comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? itemData.mealUpchargePrice :  itemData.promotionPrice) ?? [])

 if selectedItem?.selectedVarient != nil{
 if (entity.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 // CHECK VARIENT PRICE

 let varientPrice = ((entity.applyPrice ?? false) ? entity.price :  selectedItem?.selectedVarient?.price) ?? 0

 itemPrice = Global.getPriceForItem(price: varientPrice,mealID: self.comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 }
 }

 // SET BOX ITEMS IF BOX HAS DEFAULT ITEMS
 setBoxItemsDefaultItemsNotChange()

 let shrEntity = MealBundleSubEntityData(strMealId: comboObj?.mealId,
 strSelectedEntityId: itemData.id,
 strSelectedBundleEntityID: itemData.parentComboBundleEntityId,
 parentBundleId: mealItem?.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.getItemName(selectedVariant: selectedItem?.selectedVarient),
 Quentity: Int(thStepper?.value ?? 0),
 PricePerItem: (itemPrice ?? 0),
 Price: (itemPrice ?? 0) * Double(comboObj?.Quentity ?? 0),
 baseItemPrice: itemPrice ?? 0,
 selectedVarient: selectedItem?.selectedVarient,
 mealVarientUpcharge: itemPrice ?? 0,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 selectedBoxItems: self.selectedItem?.selectedBoxItem,
 itemType: itemData.itemType,
 isRecursiveSubItemForCombo:!recursiveEntityId.isEmpty  ,
 recursiveDataFromEntityGroupID: recursiveEntityId .isEmpty ? nil : recursiveEntityId)

 var tempData = comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []

 //                    if editedIndex != nil{
 //                        tempData[editedIndex!] = .subItem(shrEntity)
 //                    }else{
 tempData.append(.subItem(shrEntity))
 //                    }

 comboObj?.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 comboItemSelectioCompletion?(self.comboObj!)

 self.navigationController?.popViewController(animated: false)

 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 }

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }

 private func updateCartItem(cartData:CartData){
 CartModule().ChangeRemoveState(forCartEntityId: cartData.cartEntityID, vc: self){[weak self] isDone in
 guard let self = self else{return}
 if isDone{
 self.editCartEntityCompletion?()
 self.navigationController?.popViewController(animated: true)
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .somethingWentWrong) { isSuccess in
 self.view.alpha = 1
 }
 }
 }
 }

 private func setUIAccordingScreenType(){
 switch itemDetailScreenType{
 case .forCartAdd:
 btnAddToOrder.setTitle("Add to order", for: .normal)
 btnAddToOrder.isSelected = false
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Make it a meal", for: .normal)
 btnMakeItMeal.isSelected = true
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = ThemeColors.red.getColor
 btnMakeItMeal.setTitleColor(.white, for: .normal)
 btnMakeItMeal.layer.borderWidth = 0
 if isRunAsMealAction{
 // timmie minis flow..
 btnMakeItMeal.setTitle("Add to order", for: .normal)
 btnAddToOrder.isHidden = true
 btnAddToOrder.setIsSelectedPrimery()
 }
 case .editCartItem(_),.editBoosterItem(_):
 btnAddToOrder.setTitle("Save changes", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Remove", for: .normal)
 btnMakeItMeal.isSelected = false
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1
 case .forMealItemSelection :
 btnAddToOrder.setTitle("Add to Meal", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()
 case .forComboItemSelection,.forComboItemChange(_) :
 btnAddToOrder.setTitle("Add to Deal", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.isHidden = true
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1

 case .forComboMealAdd,.forComboRecusiveItemSelection(_):
 btnAddToOrder.setTitle("Add to Deal", for: .normal)
 btnAddToOrder.isSelected = false
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Make it a meal", for: .normal)
 btnMakeItMeal.isSelected = true
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = ThemeColors.red.getColor
 btnMakeItMeal.setTitleColor(.white, for: .normal)
 btnMakeItMeal.layer.borderWidth = 0
 if isRunAsMealAction{
 // timmie minis flow..
 btnMakeItMeal.setTitle("Add to Deal", for: .normal)
 btnAddToOrder.isHidden = true
 btnAddToOrder.setIsSelectedPrimery()
 }

 case .forMealEditCustomiser(_),.forComboEditSubItemCustomiser(_,_):
 btnAddToOrder.setTitle("Save changes", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Cancel", for: .normal)
 btnMakeItMeal.isSelected = false
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.isHidden = false
 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 case .forMealItemChange :
 btnAddToOrder.setTitle("Add to Meal", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.isHidden = true
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1
 case .forMealRootCustomiserChange(_):
 btnAddToOrder.setTitle("Save changes", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Cancel", for: .normal)
 btnMakeItMeal.isSelected = false
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1

 case .forCartAddFromLoyalityWithBooster(_):
 btnAddToOrder.setTitle("Add to order", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Make it a meal", for: .normal)
 btnMakeItMeal.isSelected = true
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.backgroundColor = ThemeColors.red.getColor
 btnMakeItMeal.setTitleColor(.white, for: .normal)
 btnMakeItMeal.layer.borderWidth = 0
 btnMakeItMeal.isHidden = true

 case .forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _):
 btnAddToOrder.setTitle("Add to order", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Make it a meal", for: .normal)
 btnMakeItMeal.isSelected = true
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.backgroundColor = ThemeColors.red.getColor
 btnMakeItMeal.setTitleColor(.white, for: .normal)
 btnMakeItMeal.layer.borderWidth = 0
 btnMakeItMeal.isHidden = true
 if isRunAsMealAction{
 // Offer On Meal
 btnMakeItMeal.setTitle("Add to order", for: .normal)
 btnAddToOrder.isHidden = true
 btnMakeItMeal.isHidden = false
 btnMakeItMeal.setIsSelectedPrimery()
 }
 case .forEditOfferItemCustomiser(_, _, _):
 btnAddToOrder.setTitle("Save changes", for: .normal)
 btnAddToOrder.isSelected = true
 btnAddToOrder.setIsSelectedPrimery()

 btnMakeItMeal.setTitle("Cancel", for: .normal)
 btnMakeItMeal.isSelected = false
 btnMakeItMeal.setIsSelectedPrimery()

 btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = false
 btnMakeItMeal.backgroundColor = .clear
 btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 btnMakeItMeal.layer.borderWidth = 1

 case .forComboAddFromReviewScreen:
 btnAddToOrder.setTitle("Add to Deal", for: .normal)
 DispatchQueue.main.async {
 self.btnAddToOrder.isSelected = true
 self.btnAddToOrder.setIsSelectedPrimery()
 self.btnMakeItMeal.setTitleColor(ThemeColors.red.getColor, for: .normal)
 self.btnMakeItMeal.isHidden = true
 self.btnAddToOrder.isHidden = false
 self.btnMakeItMeal.backgroundColor = .clear
 self.btnMakeItMeal.layer.borderColor = ThemeColors.red.getColor.cgColor
 self.btnMakeItMeal.layer.borderWidth = 1
 }

 if isRunAsMealAction{
 // MEAL flow..
 btnMakeItMeal.setTitle("Add to Deal", for: .normal)
 btnMakeItMeal.isHidden = false
 btnAddToOrder.isHidden = true
 btnMakeItMeal.isSelected = true
 btnMakeItMeal.setIsSelectedPrimery()
 }
 break
 }
 }

 private func getComboDataForAttachment(attachment:Attachment,currentComboBundle:BundleMealList,currentBundleEntity:Entity,parentComboEntityId:String) {

 if var comboObj = MenuModule().getComboMealData(mealId: attachment.entity ?? "", isComingFromAttachment: true, attachmentId: attachment.id ?? ""){
 comboObj.isFromAttachment = true
 let subItems = comboObj.arrComboBundleItems ?? []
 if !subItems.isEmpty{
 comboObj.Quentity = Int(thStepper?.value ?? 1)
 if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == currentComboBundle.id}){

 let price = ((currentBundleEntity.applyPrice ?? false) ? currentBundleEntity.price :  itemData.price) ?? 0

 var itemPrice:Double? = Global.getPriceForItem(price: price, mealID: comboObj.mealId ?? "", arrayPromoptionPrice: ((currentBundleEntity.applyPrice ?? false) ? itemData.mealUpchargePrice :  itemData.promotionPrice) ?? [])

 if selectedItem?.selectedVarient != nil && !(currentBundleEntity.variantType ?? []).isEmpty{
 if (currentBundleEntity.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
 // CHECK VARIENT PRICE

 let varientPrice = ((currentBundleEntity.applyPrice ?? false) ? currentBundleEntity.price :  selectedItem?.selectedVarient?.price) ?? 0

 itemPrice = Global.getPriceForItem(price: varientPrice,mealID: comboObj.mealId ?? "", arrayPromoptionPrice: ((currentBundleEntity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
 }else{
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 return
 }
 }else if selectedItem?.selectedVarient != nil && (currentBundleEntity.variantType ?? []).isEmpty{

 // CHECK VARIENT PRICE

 let varientPrice = ((currentBundleEntity.applyPrice ?? false) ? currentBundleEntity.price :  selectedItem?.selectedVarient?.price) ?? 0

 itemPrice = Global.getPriceForItem(price: varientPrice,mealID: comboObj.mealId ?? "", arrayPromoptionPrice: ((currentBundleEntity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
 }

 // SET BOX ITEMS IF BOX HAS DEFAULT ITEMS
 setBoxItemsDefaultItemsNotChange()

 let shrEntity = MealBundleSubEntityData(strMealId: comboObj.mealId,
 strSelectedEntityId: itemData.id,
 strSelectedBundleEntityID: parentComboEntityId,
 parentBundleId: currentComboBundle.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.title ?? "",
 Quentity: 1,
 PricePerItem: itemPrice,
 Price: (itemPrice ?? 0) * Double(comboObj.Quentity ?? 0),
 baseItemPrice: itemPrice ?? 0,
 selectedVarient: selectedItem?.selectedVarient,
 mealVarientUpcharge: itemPrice ?? 0,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 selectedBoxItems: self.selectedItem?.selectedBoxItem,
 itemType: itemData.itemType,
 isRecursiveSubItemForCombo: false,
 recursiveDataFromEntityGroupID: nil)

 var tempData = comboObj.arrComboBundleItems?[currentSubItemIndex].arrSubItem ?? []


 tempData.append(.subItem(shrEntity))


 comboObj.arrComboBundleItems?[currentSubItemIndex].arrSubItem = tempData

 self.handleCurrentAttachmentBundleItemsAndMoveNextIfSatisfy(currentComboBundle: currentComboBundle, comboData: comboObj)

 }else{
 self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
 }
 }
 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 return
 }
 }
 private func pushToComboPromptEntityListing(comboData:ComboData,currentBundle:BundleMealList){
 let objVC = self.instantiateVC(.meal, vc: ComboBundleItemsViewController.self)
 objVC.comboData = comboData
 objVC.currentMealBundle = currentBundle
 objVC.bundleItemsListingType = .promptCategory
 self.show(objVC, sender: self)
 }
 private func pushToComboItemsListingScreen(arrItems:[ItemListData],currentBundle:BundleMealList?,comboData:ComboData){
 let detailVC:ComboBundleItemsViewController = self.instantiateVC(.meal, vc: ComboBundleItemsViewController.self)

 detailVC.arrCategoryItemList = arrItems
 detailVC.currentMealBundle =  currentBundle
 detailVC.comboData = comboData
 detailVC.bundleItemsListingType = .listAllBundleItems
 detailVC.isScreenMode  = .comboSubCategoryAdd
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 private func handleComboPromptEntity(forBundle:BundleMealList,comboObj:ComboData){
 var comboData = comboObj
 if let mealData = comboData.mealData{
 let currentUpdatedBundle = forBundle
 if let Index =  mealData.bundles?.firstIndex(where: {$0.id == forBundle.id}){
 comboData.mealData?.bundles?[Index] = forBundle
 }

 if let newBundle = MenuModule().getBundleToSelectCombo(mealData: comboData.mealData ?? mealData){

 if newBundle.promptEntity ?? false{
 // Show Prompt Screen
 pushToComboPromptEntityListing(comboData: comboData, currentBundle: newBundle)

 }else{
 // Show All Items To This Screen
 _progressBar.showProgressBar(uiView: self.view)
 MenuModule().getAllItemsOfBundle(currentBundle: newBundle, mealId: comboData.mealId ?? "") { [weak self] arrItems, msg in
 guard let self = self else {return}
 _progressBar.hideProgressBar(uiView: self.view)

 if !arrItems.isEmpty{
 self.pushToComboItemsListingScreen(arrItems: arrItems, currentBundle: newBundle, comboData: comboData)
 }else{
 self.showAlert(errorMessage: Global.ErrorMessages.mealItemNotFound)
 }
 }
 }

 }else{
 // All Bundle completed
 DispatchQueue.main.asyncAfter(deadline: .now()) {
 let detailVC:ComboReviewController = self.instantiateVC(.meal, vc: ComboReviewController.self)
 detailVC.hidesBottomBarWhenPushed = true
 detailVC.comboData = comboData
 self.navigationController?.pushViewController(detailVC, animated: true)
 }
 }
 }
 }

 private func handleCurrentAttachmentBundleItemsAndMoveNextIfSatisfy(currentComboBundle:BundleMealList,comboData:ComboData){
 var currentBundle = currentComboBundle
 let result = currentBundle.checkIsBundleCompletedForCombo(comboData: comboData)
 switch result{
 case .mainItemRequired(let result, let availableQty, let currentBundle):
 if !(result){
 //                self.showAlert(errorMessage: "You have to select \(String(describing: availableQty)) more \(String(describing: currentBundle.name ?? ""))"){[weak self] in
 //                    guard let self = self else {return}
 self.handleComboPromptEntity(forBundle: currentBundle, comboObj: comboData)
 //                }
 }else{
 // Bundle SatisFy requirements now move to next bundle
 self.handleComboPromptEntity(forBundle: currentBundle, comboObj: comboData)
 }
 case .recursiveItemsPopUpShow(let arr):
 let objVC = self.instantiateVC(.meal, vc: ComboBundleItemsViewController.self)
 objVC.comboData = comboData
 objVC.currentMealBundle = currentBundle
 objVC.bundleItemsListingType = .recusiveEntitys(arr)
 self.show(objVC, sender: self)
 break
 }

 }
 private func performBaseSetUpForAttachmentItem(newItemData:ItemListData,attachment:Attachment,currentComboBundle:BundleMealList,currentBundleEntity:Entity){

 if self.selectedItem?.selectedVarient != nil{
 let containSelectedVarient = newItemData.variants?.contains(where: {$0.id == self.selectedItem!.selectedVarient!.id}) ?? false
 if !containSelectedVarient{
 //self.showAlert(debugErrorMessage: "Your selected variant not available in attachment", liveErrorMessage: "")
 self.btnAddToOrderClick(btnAddToOrder)
 return
 }
 }

 self.getComboDataForAttachment(attachment: attachment, currentComboBundle: currentComboBundle, currentBundleEntity: currentBundleEntity, parentComboEntityId: newItemData.parentComboBundleEntityId ?? "")

 }

 @objc private func getOfferDataForComboData(_ notification:Notification){
 if let offerData = notification.object as? OffersModel{
 print("Success Offer Data through notification")
 DispatchQueue.main.async {
 self.navigationController?.popToViewController(self, animated: false)
 if offerData.combo_offer_added_from_attachment != nil{
 self.addOfferToComboDataAndStartAttachmentFlow(offerData: offerData)
 }else{
 self.addOfferToComboData_ADD_FROMREVIEW(offerData: offerData)
 }
 self.removeObserverForOfferAddForComboData()
 }
 }
 }
 private func addObserverForOfferAddForComboData(parentAttachment:Attachment?){
 if parentAttachment != nil{
 // combo obj is nil in this case if offerData added just attachment flow started
 // Special case offer added from first bundle item binded entity group
 self.comboObj = MenuModule().getComboMealData(mealId: parentAttachment?.entity ?? "", isComingFromAttachment: (parentAttachment != nil) ? true : false, attachmentId: (parentAttachment?.id) ?? "")

 if self.comboObj == nil{
 self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
 return
 }
 }
 _notificationCenter.addObserver(self, selector: #selector(getOfferDataForComboData(_:)), name: .offerSelectedForCombo, object: nil)
 }
 private func removeObserverForOfferAddForComboData(){
 _notificationCenter.removeObserver(self, name: .offerSelectedForCombo, object: nil)
 }
 private func checkComboEntityHasAnyOfferOtherWiseContinueFlow(newItemData:ItemListData,attachment:Attachment,currentComboBundle:BundleMealList,currentBundleEntity:Entity,isIgnorePromotionAttachment:Bool){

 // CHECK FOR COMBO HAS ANY OFFERS TO SHOW BINDED WITH ENTITY
 if (currentBundleEntity.promotion ?? []).isEmpty || isIgnorePromotionAttachment{
 // CONTINUE COMBO FLOW
 self.performBaseSetUpForAttachmentItem(newItemData: newItemData, attachment: attachment, currentComboBundle: currentComboBundle, currentBundleEntity: currentBundleEntity)
 }else{
 // ADD ATTACHMENT FOR OFFERS BINDED IN ENTITY
 var promoAttachments : [Attachment] = []

 _ = currentBundleEntity.promotion?.map({ promotionID in

 if let offer = Tbl_Promotion.getRecords(id: promotionID, in: _coreDataShared.getContext())?.first{

 promoAttachments.append(Attachment(attachmentType: .promotion,entity: offer._id,title: offer.title, image: offer.image,id: offer._id))
 }
 })

 if !promoAttachments.isEmpty{
 // ASK FOR OFFER GO THOROUGH WITH COMBO

 if (itemData.variants?.count ?? 0 == 0) {
 mealItem = currentComboBundle
 let tempSelectedItem = self.selectedItem
 self.itemData.parentComboBundleEntityId = currentBundleEntity.id
 self.selectedItem = tempSelectedItem
 self.showAttachment(attachments: promoAttachments, parentAttachment: attachment)
 }
 else {
 getAttachmentOnVariants(attachments: promoAttachments) { arr  in
 if !arr.isEmpty {
 self.mealItem = currentComboBundle
 let tempSelectedItem = self.selectedItem
 self.itemData.parentComboBundleEntityId = currentBundleEntity.id
 self.selectedItem = tempSelectedItem
 self.showAttachment(attachments: arr, parentAttachment: attachment)
 }else{
 // ANY PROMOTION NOT SATISFY CURRENT SELECTED VARIANT
 // CONTINUE COMBO FLOW
 self.performBaseSetUpForAttachmentItem(newItemData: newItemData, attachment: attachment, currentComboBundle: currentComboBundle, currentBundleEntity: currentBundleEntity)
 }
 }
 }
 }else{
 // PROMOTION NOT FOUND CONTINUE COMBO FLOW
 self.performBaseSetUpForAttachmentItem(newItemData: newItemData, attachment: attachment, currentComboBundle: currentComboBundle, currentBundleEntity: currentBundleEntity)
 }
 }
 }
 private func pushToSelectOfferItemScreen(offerModel:OffersModel,attachment:Attachment,parentAttachment:Attachment?){
 var offersModel = offerModel
 offersModel.addSelectedItemsForOffer()
 let tempSelectedItem = self.selectedItem
 self.itemData.parentOfferEntityGroupDetails = attachment.offerEntityGroupFrom
 self.selectedItem = tempSelectedItem
 if parentAttachment != nil || !(itemData.parentComboBundleEntityId ?? "").isEmpty{
 offersModel = addOfferSelectedItem(offerModel: offersModel)

 // SET OFFER ADDED FROM FIRST BUNDLE MEANS STARTING ATTACHMENT AND USER CHOOSE OFFER SO CONTINUE ATTACHMENT FLOW
 offersModel.combo_offer_added_from_attachment = parentAttachment
 }
 LoyaltyModule().getOfferItemsNames(obj: offersModel) {  arrayData in

 let vc:OfferItemsViewController = self.instantiateVC(.profile, vc: OfferItemsViewController.self)
 vc.arrayOfferEntityGroupDetails = arrayData
 vc.offerModel = offersModel
 vc.screenType = .oferAddFromCombo
 self.addObserverForOfferAddForComboData(parentAttachment: parentAttachment)
 self.navigationController?.pushViewController(vc, animated: true)
 }
 }
 private func handleSelectedAttachements(attachment: Attachment,parentAttachment:Attachment?,isIgnorePromotionAttachment:Bool) {
 switch attachment.attachmentType {
 case .promotion:
 LoyaltyModule().getOffersData { arrOfferModel, error in
 if error == nil {

 if var offerModel  = arrOfferModel?.first(where: {$0._id == attachment.entity}){
 LoyaltyModule().validateOfferData(offerModel: offerModel) { [weak self]  (type) in
 guard let self = self else{return}

 switch type{
 case .result(let isOfferValid,let msg):
 if isOfferValid{

 let offerType = EnumDiscountApplyOn(rawValue:offerModel.discount_apply?.type ?? "price") ?? .price

 switch offerType {
 case .price:
 CartModule().callCheckDeviceAtCurrentMenu { [weak self] obj in
 guard let self = self else{return}
 DispatchQueue.main.async {
 _progressBar.hideProgressBar(uiView: self.view)
 }
 if offerModel.discount_apply?.apply_on_entity == false && offerModel.discount_apply?.apply_on_order_basket == true{

 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .common(msg: "Basket offer not allowed..")) { isSuccess in
 self.view.alpha = 1
 }

 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .common(msg: "Sorry we are unable to proceed with this offer..")) { isSuccess in
 self.view.alpha = 1
 }
 }
 }
 case .entity:
 self.pushToSelectOfferItemScreen(offerModel: offerModel, attachment: attachment, parentAttachment: parentAttachment)
 }
 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .common(msg: msg)) { isSuccess in
 self.view.alpha = 1
 }
 }
 case .selecteItemForApplyOffer(let isOfferValid,let msg, let arrayData):

 //                                if let itemData =  arrayData?.first(where: {$0.id == self.itemData.id}){
 //
 //                                    self.performBaseSetUpForAttachmentItem(newItemData: itemData, attachment: attachment, currentComboBundle: attachmentBundle, currentBundleEntity: entity)
 //
 //                                }else{
 //                                    self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 //                                }

 if !arrayData.isEmpty && !arrayData.first!.ruleItems.isEmpty{

 self.pushToSelectOfferItemScreen(offerModel: offerModel,attachment: attachment, parentAttachment: parentAttachment)


 }else{
 self.view.alpha = 0.5
 self.showThemeAlertVC(type: .common(msg: "Sorry we are unable to proceed with this offer..")) { isSuccess in
 self.view.alpha = 1
 }
 }
 }

 }
 }
 }
 }
 break
 case .meal:
 MenuModule().getMealItemFromMakeItMeal(strMealId: attachment.entity ?? "") { [weak self]  arrMealData,errMsg in
 guard let self = self else{return}
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 if arrMealData?.count ?? 0 > 0 {
 // Find bundle
 if let attachmentBundle = arrMealData?.first?.bundles?.first{

 MenuModule().getComboEntityDetails(attachmentBundle.entity ?? [], mealID: attachment.entity ?? "" , isIgnoreRootDisplay: true) { arrItemList, msg in
 if let itemData =  arrItemList?.first(where: {$0.id == self.itemData.id}){
 if let entity = attachmentBundle.entity?.first(where: {$0.id == itemData.parentComboBundleEntityId}){

 self.checkComboEntityHasAnyOfferOtherWiseContinueFlow(newItemData: itemData, attachment: attachment, currentComboBundle: attachmentBundle, currentBundleEntity: entity, isIgnorePromotionAttachment: isIgnorePromotionAttachment)

 }else{
 self.showAlert(errorMessage: Global.alertMessageConfigrationIssue)
 }
 }else{
 self.showAlert(errorMessage: Global.alertMessageConfigrationIssue)
 }
 }
 }
 }
 }
 case .none:
 self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
 break
 }

 }


 private func showAttachment(attachments: [Attachment],parentAttachment:Attachment?) {
 var arrAttachentShowIn = [Attachment]()
 switch itemDetailScreenType {
 //        case .forCartAdd, .editCartItem(_):
 //
 //            arrAttachentShowIn = attachments.filter({($0.showIn == .individual) || ($0.showIn == .all)})
 //
 //        case .forMealItemSelection, .forMealItemChange, .forMealEditCustomiser(_), .forMealRootCustomiserChange(_):
 //
 //            arrAttachentShowIn = attachments.filter({($0.showIn == .meal) || ($0.showIn == .all)})
 //
 //        case .forComboItemSelection, .forComboMealAdd, .forComboEditSubItemCustomiser(_ , _),.forComboItemChange(_):
 //
 //            arrAttachentShowIn = attachments.filter({($0.showIn == .promotion) || ($0.showIn == .all)})
 //
 //        case .forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _):
 //
 //            arrAttachentShowIn = attachments.filter({($0.showIn == .promotion) || ($0.showIn == .all)})
 //
 case .forCartAdd, .editCartItem(_), .forMealItemSelection, .forMealItemChange, .forMealEditCustomiser(_), .forMealRootCustomiserChange(_), .forComboItemSelection, .forComboMealAdd, .forComboEditSubItemCustomiser(_ , _),.forComboItemChange(_), .forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _):

 // isCurrentDateBetween
 // isCurrentTimeBetween
 if self.comboObj == nil {
 let storeData: StoreInfoModel? = Global.getModelFromUserDefault(model: StoreInfoModel.self, key: .currentRestaurantDetails)

 attachments.forEach { element in
 if element.apply_on_restaurant?.count ?? 0 > 0 {
 if ((element.apply_on_restaurant?.contains(where: {$0 == storeData?._id})) ?? false) {
 if Global.isCurrentDateBetween(startDate: element.start_date, endDate: element.end_date, isUTC: true) {
 let result = LoyaltyModule.checkBoosterAppilicableOnToday(data: element.days!, checkOn: "")
 if result.0 {
 if Global.isCurrentTimeBetween(startTime: element.display_start_time, endTime: element.display_end_time, isAdd59Sec: true) {
 arrAttachentShowIn.append(element)
 }
 }

 }
 }
 }
 else {
 if Global.isCurrentDateBetween(startDate: element.start_date, endDate: element.end_date, isUTC: true) {
 let result = LoyaltyModule.checkBoosterAppilicableOnToday(data: element.days!, checkOn: "")
 if result.0 {
 if Global.isCurrentTimeBetween(startTime: element.display_start_time, endTime: element.display_end_time, isAdd59Sec: true) {
 arrAttachentShowIn.append(element)
 }
 }

 }

 //                    if ((element.apply_on_restaurant?.contains(where: {$0 == storeData?._id})) != nil) {
 //
 //                        }
 }

 }
 }



 //If Check attachment available in Restarurent or not if yes then
 // check Attachment available on curent Date range or not
 // check Attachment available on current day
 // Show attachment
 //Else
 // don't show Attachment
 case .editBoosterItem(_),.forCartAddFromLoyalityWithBooster(_):
 isCancleAttachment = true
 btnAddToOrderClick(self.btnAddToOrder)
 return
 case .forComboRecusiveItemSelection:
 break
 case .forComboAddFromReviewScreen:
 break

 }

 if arrAttachentShowIn.count > 0 {
 let vc:AttachmentBottomViewController = self.instantiateVC(.common, vc: AttachmentBottomViewController.self)
 vc.modalTransitionStyle = .coverVertical
 vc.modalPresentationStyle = .overFullScreen
 vc.arrAttachment = arrAttachentShowIn
 vc.completionOfAttachment = { [weak self] attachment, iscancel, isclose in
 guard let self = self else{return}
 if isclose {
 self.view.alpha = 1
 }
 else {
 self.view.alpha = 1
 self.isCancleAttachment = iscancel
 if !iscancel {
 // HANDLE SELECTED ATTACHMENT AND CHECK IF IT HAS ANY PROMOTION BINDED
 self.handleSelectedAttachements(attachment: attachment!, parentAttachment: parentAttachment, isIgnorePromotionAttachment: false)
 }else{
 if parentAttachment != nil{
 // HANDLE ONGOING ATTACHMENT & IGNORE PROMOTION ATTACHMENTS
 self.handleSelectedAttachements(attachment: parentAttachment!, parentAttachment: nil, isIgnorePromotionAttachment: true)
 }else{
 // CONTINUE ON GOING FLOW
 self.btnAddToOrderClick(self.btnAddToOrder)
 }
 }
 }
 }
 self.view.alpha  = 0.5
 self.present(vc, animated: true)
 }else{
 isCancleAttachment = true
 btnAddToOrderClick(self.btnAddToOrder)
 }
 }

 private func checkIsDefaultDressingDippingSet() -> Bool{
 var defaultCustmIds = [String]()
 var selectedCustomIds = [String]()

 let arrDefaultCustm = getCustomiseData(customiseData: itemData.modifiers?.customize ?? [])
 let arrSelectedCustm = getCustomiseData(customiseData: selectedItem?.selectedCustomiser ?? [])
 if  !arrDefaultCustm.isEmpty{
 _ = arrDefaultCustm.map { customizer in
 customizer.modifierList?.map({ mods in
 if (mods.currentValue ?? 0)  > 0 && (mods.currentValue != mods.defaultState)  {
 defaultCustmIds.append(mods.id ?? "")
 }
 })
 }
 }

 if !arrSelectedCustm.isEmpty {
 _ = arrSelectedCustm.map { customizer in
 customizer.modifierList?.map({ mods in
 if (mods.currentValue ?? 0)  > 0 && (mods.currentValue != mods.defaultState) {
 selectedCustomIds.append(mods.id ?? "")
 }
 })
 }
 }
 return Set(defaultCustmIds) == Set(selectedCustomIds)
 }

 private func checkIsDefaultCustomizerSet() -> Bool{
 var isSameData = true
 let arrSelectedCustm = selectedItem?.selectedCustomiser ?? []

 if !arrSelectedCustm.isEmpty {
 for customizer in arrSelectedCustm{

 for modList in (customizer.modifierList ?? []){
 if (modList.currentValue ?? 0) != (modList.defaultState ?? 0){
 isSameData = false
 break
 }else{
 continue
 }
 }
 }
 }
 return isSameData
 }

 func setCustomizedItemPriceAtInit() {
 var totlaCountedPriceAfterEdit : Double = 0

 //var defaultCustmIds = [String]()
 //var selectedCustomIds = [String]()

 let arrDefaultCustm = getCustomiseData(customiseData: itemData.modifiers?.customize ?? [])
 let arrSelectedCustm = getCustomiseData(customiseData: selectedItem?.selectedCustomiser ?? [])

 if  !arrDefaultCustm.isEmpty{
 _ = arrDefaultCustm.map { customizer in
 if customizer.isQuantifiable ?? false {
 customizer.modifierList?.map({ mods in
 if (mods.currentValue ?? 0)  > 0 && (mods.currentValue != mods.defaultState)  {
 let modifirelistData : ModifierListAPIData? = customizer.modifireDetails?.first(where: { ($0.id ?? "") == (mods.modifier ?? "")})
 var price : Double = 0
 let quentity = (mods.currentValue ?? 0) - (mods.includedFreeItem ?? 0)
 if quentity > 0 {
 price  = Double(quentity) * (Double(modifirelistData?.price ?? "0") ?? 0)
 }
 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + price
 }
 })
 }
 else {
 _ = customizer.modifierList?.map({ mods in
 if (mods.isSelected ?? false)  {

 var price : Double = 0
 let modData = customizer.modifireDetails?.first(where: {$0.id == mods.modifier})
 price  = Double(1) * (Double(modData?.price ?? "0") ?? 0)

 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + price
 }
 })
 }

 }
 }

 if !arrSelectedCustm.isEmpty {
 _ = arrSelectedCustm.map { customizer in
 customizer.modifierList?.map({ mods in
 if (mods.currentValue ?? 0)  > 0 && (mods.currentValue != mods.defaultState) {
 //selectedCustomIds.append(mods.id ?? "")
 }
 })
 }
 }

 sumOfMods += totlaCountedPriceAfterEdit
 setUpdatedPrice()
 }

 func setCustomizedItemPrice(){
 lblSelectedItemList.isHidden = true
 let checkIsDefaultCustomizerSet = checkIsDefaultCustomizerSet()
 lblSelectedItemList.text = ""
 strSelectedDressingDipping = ""
 sumOfMods = 0

 setUpdatedPrice()

 if !(itemData.isMultibox ?? false) {
 if selectedItem?.selectedCustomiser != nil && !checkIsDefaultCustomizerSet{
 var strSelected = ""
 var strSelectedSouce = ""
 //let selectedModifire = selectedItem!.selectedCustomiser?.compactMap({$0.id}).sorted(by: {$0 > $1})
 var totlaCountedPriceAfterEdit : Double = 0

 let lastCustomiserIndex = (selectedItem?.selectedCustomiser?.count ?? 0) - 1
 _ = selectedItem?.selectedCustomiser?.enumerated().map({ data in
 // if data.isQuantifiable ?? false {
 let isLastData = lastCustomiserIndex == data.offset
 if data.element.isQuantifiable ?? false {
 let modificationData = data.element.modifierList?.filter({ $0.changeInDefaultState != 0})
 _ = modificationData?.enumerated().map({ list in
 let name = (data.element.modifireDetails?.first(where: {$0.id == list.element.modifier})?.title) ?? "Customizer"
 let lastMOd = isLastData && (list.offset == modificationData!.count-1)
 strSelected = "\(strSelected) \(String(describing: list.element.changeInDefaultState ?? 0)) x \(String(describing: name))\(lastMOd ? "" : ", ")"

 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + (list.element.extraItemPriceCalculaiton ?? 0)
 })

 }
 else {

 let modificationData = data.element.modifierList?.filter({$0.isSelected == true  && ($0.isPreferred == false)})
 _ = modificationData?.enumerated().map({ list in
 let modDetail = data.element.modifireDetails?.first(where: {$0.id == list.element.modifier})
 let name = modDetail?.title ?? ""
 let lastMOd = isLastData && (list.offset == modificationData!.count-1)
 strSelectedSouce = "\(strSelectedSouce) \(name)\(lastMOd ? "" : ", ")"
 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + (list.element.extraItemPriceCalculaiton ?? 0)
 })

 }

 })
 strSelected += strSelectedSouce
 sumOfMods += totlaCountedPriceAfterEdit
 setUpdatedPrice()

 lblSelectedItemList.text = "Your changes :\(strSelected)"
 if strSelected.isEmpty {
 lblSelectedItemList.isHidden = true
 }
 else {
 lblSelectedItemList.isHidden = false
 }
 }
 if let selectedDressingDipping = selectedItem?.selectedDressingDipping,!selectedDressingDipping.isEmpty {
 let arrayDressingDiping = selectedDressingDipping
 var strSelected = ""
 var strSelectedSouce = ""

 var totlaCountedPriceAfterEdit : Double = 0

 if !arrayDressingDiping.isEmpty{ // verfying if selected dressing dipping exist
 let lastCustomiserIndex = selectedDressingDipping.count - 1
 _ = selectedDressingDipping.enumerated().map({ data in

 let isLastData = lastCustomiserIndex == data.offset
 //let modificationData = data.modifierList?.filter({($0.currentValue ?? 0) > 0 })
 if data.element.isQuantifiable ?? false {
 let modificationData = data.element.modifierList?.filter({ $0.changeInDefaultState != 0})
 _ = modificationData?.enumerated().map({ list in
 let name = (data.element.modifireDetails?.first(where: {$0.id == list.element.modifier})?.title) ?? "Customizer"
 let lastMOd = isLastData && (list.offset == modificationData!.count-1)
 strSelected = "\(strSelected) \(String(describing: list.element.changeInDefaultState ?? 0)) x \(String(describing: name))\(lastMOd ? "" : ", ")"

 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + (list.element.extraItemPriceCalculaiton ?? 0)
 })
 self.strSelectedDressingDipping = strSelected
 //                            lblSelectedItemList.text = "Your changes :\(strSelected)"
 //                            if strSelected.isEmpty {
 lblSelectedItemList.isHidden = true
 //                            }
 //                            else {
 //                                lblSelectedItemList.isHidden = false
 //                            }
 }
 else {
 let modificationData = data.element.modifierList?.filter({$0.isSelected == true && ($0.isPreferred == false)})
 _ = modificationData?.enumerated().map({ list in
 let modDetail = data.element.modifireDetails?.first(where: {$0.id == list.element.modifier})
 let name = modDetail?.title ?? ""
 let lastMOd = isLastData && (list.offset == modificationData!.count-1)
 strSelected = "\(strSelected) \(name)\(lastMOd ? "" : ", ")"
 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + (list.element.extraItemPriceCalculaiton ?? 0)
 self.strSelectedDressingDipping = strSelected
 })
 }

 })
 sumOfMods += totlaCountedPriceAfterEdit
 setUpdatedPrice()

 if !isShowDippingDressing {
 lblSelectedItemList.text = "\(lblSelectedItemList.text ?? "")   \(self.strSelectedDressingDipping)"
 lblSelectedItemList.isHidden = false
 }
 //lblSelectedItemList.text?.dropLast(2)

 self.tblMealItems.reloadData()
 }
 }


 }else if selectedItem?.selectedBoxItem?.count ?? 0 > 0 {
 var strSelected = ""
 var totlaCountedPriceAfterEdit : Double = 0
 let array = selectedItem?.selectedBoxItem?.filter({($0.chageIndefaultState ?? 0) != 0}) ?? []
 if !array.isEmpty{
 selectedItem?.selectedBoxItem?.forEach({ BoxlistData in
 if BoxlistData.currentValue ?? 0 > 0 {
 strSelected = "\(strSelected) \(BoxlistData.currentValue ?? 0) x \(BoxlistData.title ?? ""), "
 }
 //                if BoxlistData.chageIndefaultState != 0 && BoxlistData.chageIndefaultState != nil {
 //                    strSelected = "\(strSelected) \(BoxlistData.chageIndefaultState ?? 0) x \(BoxlistData.title ?? ""), "
 //                }

 if BoxlistData.currentValue ?? 0 > 0 {
 totlaCountedPriceAfterEdit = totlaCountedPriceAfterEdit + (BoxlistData.totalPriceAfterAllSelected ?? 0)
 }
 })
 }
 let titleStr = strSelected.isEmpty ? "" : "Your changes: "
 if strSelected.count > 2{
 (strSelected.removeLast(2))
 }
 lblSelectedItemList.text = titleStr + strSelected
 if (strSelected.isEmpty) {
 lblSelectedItemList.isHidden = true
 }
 else {
 lblSelectedItemList.isHidden = false
 }
 sumOfMods = totlaCountedPriceAfterEdit
 setUpdatedPrice()
 }
 }

 private func getCartObject()->AddToCart{
 setCustomizedItemPrice()

 let mods = CartModule().get_Arr_Tbl_Cart_Modifire_DBBind(
 arrCustomiser: selectedItem?.selectedCustomiser ?? [],
 arrDressingDipping: self.selectedItem?.selectedDressingDipping ?? [])

 if (itemData.isMultibox ?? false) && (selectedItem?.selectedBoxItem ?? []).isEmpty{
 var boxItems = selectedItem?.allBoxItems
 boxItems?.enumerated().forEach({ item in
 let boxItem = itemData.box?.first(where: {$0.item == item.element.id})
 boxItems?[item.offset].currentValue = boxItem?.defaultState
 })
 selectedItem?.selectedBoxItem = boxItems
 }
 let obj = AddToCart(quantity: Int(thStepper!.value),
 price: oldPrice,
 per_item_price: pricePerItem,
 comesFrom: "",
 isBaseItem: true,
 isMultiBox: itemData.isMultibox ?? false,
 itemName: lblTitle.text ?? "",
 itemCalorie: (selectedItem?.selectedVarient?.calorie) ?? (itemData.calorie ?? 0),
 mealId: "",
 baseItemId: itemData.current_menu_item_entity_id ?? "",
 selected_varient: selectedItem?.selectedVarient,
 selected_dressing_dipping: selectedItem?.selectedDressingDipping,
 selected_customizer: selectedItem?.selectedCustomiser,
 selected_box_item: selectedItem?.selectedBoxItem,
 mealSubItem: nil,
 modifires: mods, attachmentId: "", points_use: 0)
 return obj
 }

 func setCollectionVarient(){
 colletionVarient.reloadData()
 let array = selectedItem?.varientData ?? []
 var maxHeight:CGFloat = 0
 let width = (UIScreen.main.bounds.width - 50) / 3
 let viewHeight = (0.492424 ) * width
 for item in array{
 switch itemDetailScreenType {
 case .forCartAdd , .editCartItem(_),.forMealRootCustomiserChange(_),.editBoosterItem(_),.forCartAddFromLoyalityWithBooster(_),.forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _),.forComboItemChange(_),.forComboItemSelection,.forComboMealAdd,.forComboRecusiveItemSelection(_),.forComboAddFromReviewScreen:
 let titleHeight = UILabel().heightForView(text: (item.varientType?.name ?? "") + " \(itemData.name ?? "")", font: UIFont().getSofiaProRegularFont(16), width: width)
 let prefixHeight = UILabel().heightForView(text: item.varientType?.title ?? "", font: UIFont().getSofiaProRegularFont(19), width: width)
 //                maxPrefixHeight = (prefixHeight > maxPrefixHeight) ? (prefixHeight) : maxPrefixHeight
 let height = titleHeight + viewHeight + 15
 if height > maxHeight{
 maxHeight = height
 }

 case .forMealItemSelection, .forMealItemChange, .forMealEditCustomiser(_),.forComboEditSubItemCustomiser(_,_):
 let titleHeight = UILabel().heightForView(text: (item.varientType?.name ?? "") + " \(itemData.name ?? "")", font: UIFont().getSofiaProRegularFont(16), width: width)

 let varientPrice = UILabel().heightForView(text: item.getPriceCalMealString(freeVarientId: mealDrinkBundleEntity?.variantType ?? [], mealID: self.mealModificationData?.strMealId ?? ""), font: UIFont().getSofiaProRegularFont(16), width: width)
 let prefixHeight = UILabel().heightForView(text: item.varientType?.title ?? "", font: UIFont().getSofiaProRegularFont(19), width: width)
 //                maxPrefixHeight = (prefixHeight > maxPrefixHeight) ? (prefixHeight) : maxPrefixHeight
 let height = titleHeight + varientPrice + 10 + viewHeight
 if height > maxHeight{
 maxHeight = height
 }
 }


 }
 vwVarientHeight.constant = maxHeight
 colletionVarient.reloadData()
 }

 func setMealData(){
 var itemPrice : Double = 0.0
 setUpdatedPrice()
 itemPrice = pricePerItem

 if !(itemData.meals ?? []).isEmpty{

 self.mealModificationData = MealParentData(Id: itemData.id,
 arrCustomise: selectedItem?.selectedCustomiser,
 strMealId: itemData.meals!.first?.meal,
 Quentity: Int(thStepper!.value),
 PricePerItem: itemPrice,
 Price: (itemPrice) * thStepper!.value,
 MealSubItem: [],
 selectedVarient: selectedItem?.selectedVarient,
 selectedDressingDipping: selectedItem?.selectedDressingDipping,
 mealObj: itemData.meals?.first)
 }
 }

 func handleDippingDressing()->[Customize]{
 if let dipping  = itemData.modifiers?.dipping,!dipping.isEmpty{
 isShowDippingDressing = true
 viewMealItmes.isHidden = false
 return dipping
 }else if let dressing  = itemData.modifiers?.dressing,!dressing.isEmpty{
 isShowDippingDressing = true
 viewMealItmes.isHidden = false
 return dressing
 }else{
 isShowDippingDressing = false
 viewMealItmes.isHidden = false
 return []
 }
 }

 private func handleBoxOrItemData(){
 if itemData.isMultibox ?? false {
 self.itemType = .multibox
 if !(itemData.box ?? []).isEmpty && (itemData.allowCustomize ?? true){
 btnCustmise.isHidden = false
 btnCustmise.isUserInteractionEnabled = true
 }
 else {
 btnCustmise.isHidden = true
 btnCustmise.isUserInteractionEnabled = true
 }
 lblTitle.text = itemData.title
 let boxArray = itemData.box
 MenuModule().getBoxItems(arrayBox: boxArray ?? []) { [weak self] arrData,errMsg in
 guard let self = self else{return}
 if !errMsg.isEmpty{
 self.showAlert(errorMessage: errMsg)
 return
 }
 guard let arrData = arrData else {
 self.showAlert(errorMessage: "Box Items not found", completion: nil)
 return
 }
 self.selectedItem?.allBoxItems = arrData
 }
 self.btnCustmise.setTitle("Customise", for: .normal)
 self.getUnAvailableModifire()
 }
 else {
 showItemDetails()
 self.getUnAvailableModifire()
 }
 }
 /*
  func getData() {
  let itemType = EnumItemType(rawValue: itemData.itemType!)!
  switch itemType {
  case .normal :
  self.imgType.isHidden = true
  //  imgItem.backgroundColor = .white
  case .tuna :
  self.imgType.isHidden = true
  //  imgItem.backgroundColor = .blue
  case .veg:
  self.imgType.isHidden = false
  //imgItem.backgroundColor = .green
  case .vegan:
  self.imgType.isHidden = false
  }
  self.imgType.image = itemType.getImage
  self.imgType.contentMode = .scaleAspectFit

  switch itemDetailScreenType {
  case .forCartAdd,.forComboMealAdd,.forComboRecusiveItemSelection(_),.forComboAddFromReviewScreen :

  setUpdatedPrice()
  btnMakeItMeal.isHidden = (itemData.meals ?? []).isEmpty
  btnCustmise.isUserInteractionEnabled = true
  btnAddToOrder.isSelected =  btnMakeItMeal.isHidden ?  true : false
  btnAddToOrder.setIsSelectedPrimery()
  self.handleBoxOrItemData()

  case .forComboItemChange(_), .forComboItemSelection:

  setUpdatedPrice()
  btnMakeItMeal.isHidden = true
  btnCustmise.isUserInteractionEnabled = true
  btnAddToOrder.isSelected =  btnMakeItMeal.isHidden ?  true : false
  btnAddToOrder.setIsSelectedPrimery()
  self.handleBoxOrItemData()

  case .editCartItem(_):

  setUpdatedPrice()
  btnCustmise.isUserInteractionEnabled = true
  self.handleBoxOrItemData()

  case .forMealItemSelection:

  btnMakeItMeal.isHidden = true
  lblDescription.isHidden = false
  viewStepper.isHidden = true
  lblTitle.text = itemData.title
  btnCustmise.isHidden = false
  self.handleBoxOrItemData()

  case .forMealItemChange:

  viewStepper.isHidden = true
  lblTitle.text = itemData.title
  btnCustmise.isHidden = false
  lblDescription.isHidden = false
  self.handleBoxOrItemData()

  case .forMealEditCustomiser(let subEntityData):

  viewStepper.isHidden = true
  lblDescription.isHidden = false
  showItemDetails()
  self.selectedItem?.selectedVarient = subEntityData.selectedVarient
  self.selectedItem?.selectedCustomiser = subEntityData.arrEntityCustomise
  self.selectedItem?.selectedDressingDipping = subEntityData.selectedDressingDipping
  self.btnMakeItMeal.isHidden = false
  self.setUpdatedPrice()
  break

  case .forMealRootCustomiserChange(let mealParentData):

  viewStepper.isHidden = true
  self.btnMakeItMeal.isHidden = false
  showItemDetails()
  self.selectedItem?.selectedVarient = mealParentData.selectedVarient
  self.selectedItem?.selectedCustomiser = mealParentData.arrCustomise
  self.selectedItem?.selectedDressingDipping = mealParentData.selectedDressingDipping
  self.setUpdatedPrice()

  case .forComboEditSubItemCustomiser(let subEntityData,_):

  viewStepper.isHidden = false
  lblDescription.isHidden = false
  handleBoxOrItemData()
  self.selectedItem?.selectedVarient = subEntityData.selectedVarient
  self.selectedItem?.selectedCustomiser = subEntityData.arrEntityCustomise
  self.selectedItem?.selectedDressingDipping = subEntityData.selectedDressingDipping
  self.btnMakeItMeal.isHidden = false
  self.setUpdatedPrice()
  break

  case .forCartAddFromLoyalityWithBooster(_),.editBoosterItem(_):

  viewStepper.isHidden = true
  setUpdatedPrice()
  btnMakeItMeal.isHidden = true//(itemData.meals ?? []).isEmpty
  btnCustmise.isUserInteractionEnabled = true
  self.handleBoxOrItemData()
  self.btnMakeItMeal.isHidden = true
  self.setUpdatedPrice()

  case .forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _):
  viewStepper.isHidden = false
  setUpdatedPrice()
  btnMakeItMeal.isHidden = !isRunAsMealAction
  btnCustmise.isUserInteractionEnabled = true
  self.handleBoxOrItemData()
  //            self.btnMakeItMeal.isHidden = true
  self.setUpdatedPrice()
  break
  case .forEditOfferItemCustomiser(_, let offerSubItem, let editedIndex):
  viewStepper.isHidden = false
  setUpdatedPrice()
  btnCustmise.isUserInteractionEnabled = true
  self.handleBoxOrItemData()
  self.setUpdatedPrice()
  break
  }

  _ = self.selectedItem?.selectedCustomiser?.enumerated().map { customiser in
  if self.selectedItem?.selectedCustomiser?[customiser.offset].isQuantifiable ?? false {
  // self.selectedItem?.selectedCustomiser[customiser.offset] = setCustomiserType(obj: customiser.element)
  self.selectedItem?.selectedCustomiser?[customiser.offset] = Modifire().includedFreeItemWhenInitialize(obj: customiser.element)
  }
  }
  _ = self.selectedItem?.selectedDressingDipping?.enumerated().map { customiser in
  if self.selectedItem?.selectedDressingDipping?[customiser.offset].isQuantifiable ?? false {
  // self.selectedItem?.selectedCustomiser[customiser.offset] = setCustomiserType(obj: customiser.element)
  self.selectedItem?.selectedDressingDipping?[customiser.offset] = Modifire().includedFreeItemWhenInitialize(obj: customiser.element)
  }
  }

  }

  func setUpdatedPrice(){
  var itemPrice = Global.getPriceForItem(price: itemData.price, arrayPromoptionPrice: itemData.promotionPrice ?? []) ?? 0

  var calorieStr =  Global.singleton.returnCalaroisCalculation(calaories: itemData.calorie ?? 0, quantity: 1)

  switch itemDetailScreenType {
  case .forCartAdd,.editCartItem(_),.forMealRootCustomiserChange(_),.forCartAddFromLoyalityWithBooster(_),.editBoosterItem(_):
  if selectedItem?.selectedVarient != nil{
  itemPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.price, arrayPromoptionPrice: selectedItem?.selectedVarient?.promotionPrice ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)
  }else{
  itemPrice = Global.getPriceForItem(price: itemData.price, arrayPromoptionPrice: itemData.promotionPrice ?? []) ?? 0
  }

  case .forMealItemSelection, .forMealEditCustomiser(_),.forMealItemChange:

  // CHECK FREE
  if mealDrinkBundleEntity != nil{
  // Current meal selection  is drink item so we need to found if any free varient AVAILABLE WITH ENTITY
  if mealDrinkBundleEntity?.variantType != nil && !(mealDrinkBundleEntity?.variantType ?? []).isEmpty{
  // select free varient
  let freeVarients = mealDrinkBundleEntity!.variantType!
  //                    let varientArray = selectedItem?.varientData?.compactMap({$0.varientParentData})
  //                    let varientParent = varientArray?.first(where: {$0.variantType == freeVarient})
  if freeVarients.contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
  itemPrice = 0 // FREE
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)

  }else{
  if selectedItem?.selectedVarient != nil{
  itemPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: selectedItem?.selectedVarient?.mealUpchargePrice ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)
  }else{
  itemPrice = Global.getPriceForItem(price: itemData.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: itemData.mealUpchargePrice ?? []) ?? 0
  }
  }
  }else{
  if selectedItem?.selectedVarient != nil{
  itemPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: selectedItem?.selectedVarient?.mealUpchargePrice ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)
  }else{
  itemPrice = Global.getPriceForItem(price: itemData.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: itemData.mealUpchargePrice ?? []) ?? 0
  }
  }
  }
  else{
  if selectedItem?.selectedVarient != nil{
  itemPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: selectedItem?.selectedVarient?.mealUpchargePrice ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)
  }else{
  itemPrice = Global.getPriceForItem(price: itemData.upchargePrice,mealID: self.mealModificationData?.strMealId ?? "", arrayPromoptionPrice: itemData.mealUpchargePrice ?? []) ?? 0
  }
  }
  case .forComboItemChange(_),.forComboItemSelection,.forComboEditSubItemCustomiser(_,_),.forComboMealAdd,.forComboRecusiveItemSelection(_),.forComboAddFromReviewScreen:
  let subItems = comboObj?.arrComboBundleItems ?? []
  if !subItems.isEmpty{
  if let currentSubItemIndex = subItems.firstIndex(where: {$0.bundleId == mealItem?.id}){

  let currentSelectedEntityId = itemData.parentComboBundleEntityId ?? ""

  if let entity = mealItem?.entity?.first(where: {$0.id == currentSelectedEntityId}){

  let price = ((entity.applyPrice ?? false) ? entity.price :  itemData.price) ?? 0

  var newItemPrice:Double? = Global.getPriceForItem(price: price, mealID: comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? itemData.mealUpchargePrice :  itemData.promotionPrice) ?? [])

  if selectedItem?.selectedVarient != nil && !(entity.variantType ?? []).isEmpty{
  if (entity.variantType ?? []).contains(where: {$0 == (selectedItem?.selectedVarient?.variantType ?? "")}){
  // CHECK VARIENT PRICE

  let varientPrice = ((entity.applyPrice ?? false) ? entity.price :  selectedItem?.selectedVarient?.price) ?? 0

  newItemPrice = Global.getPriceForItem(price: varientPrice,mealID: self.comboObj?.mealId ?? "", arrayPromoptionPrice: ((entity.applyPrice ?? false) ? selectedItem?.selectedVarient?.mealUpchargePrice :  selectedItem?.selectedVarient?.promotionPrice) ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)

  }else{
  self.showAlert(errorMessage: Global.alertMessageSomethingWentWrong)
  }
  }

  itemPrice = newItemPrice ?? 0
  }else{
  self.showAlert(errorMessage: Global.ErrorMessages.mealNotFound)
  }

  }else{
  self.showAlert(errorMessage: "\(Global.alertMessageSomethingWentWrong) with meal selection", completion: nil)
  }


  }
  break
  case .forCartAddFromLoyalityWithOffers(_),.forEditOfferItemCustomiser(_, _, _),.forChangeOfferItem(_, _, _):
  if selectedItem?.selectedVarient != nil{
  itemPrice = Global.getPriceForItem(price: selectedItem?.selectedVarient?.price, arrayPromoptionPrice: selectedItem?.selectedVarient?.promotionPrice ?? []) ?? 0
  calorieStr = Global.singleton.returnCalaroisCalculation(calaories: selectedItem?.selectedVarient?.calorie ?? 0, quantity: 1)
  }else{
  itemPrice = Global.getPriceForItem(price: itemData.price, arrayPromoptionPrice: itemData.promotionPrice ?? []) ?? 0
  }
  break
  }


  pricePerItem = (itemPrice) + sumOfMods
  //        if itemPrice > 0{
  itemPrice = (itemPrice) + sumOfMods
  //        }
  let stepValue  = thStepper!.value
  let itemTotalPrice = (itemPrice) * (stepValue)
  oldPrice = itemTotalPrice
  switch itemDetailScreenType{
  case .forCartAdd,.editCartItem(_),.forMealRootCustomiserChange(_),.forCartAddFromLoyalityWithBooster(_),.forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _),.editBoosterItem(_)://,.forComboMealAdd,.forComboRecusiveItemSelection(_):

  let priceStr = itemTotalPrice == 0 ? "" : "£\(itemTotalPrice.getTwoDecimalPlacesString())  "
  lblDescription.text = priceStr + calorieStr

  case .forMealItemSelection,.forMealItemChange,.forMealEditCustomiser(_),.forComboItemChange(_),.forComboItemSelection,.forComboEditSubItemCustomiser(_,_),.forComboAddFromReviewScreen,.forComboMealAdd,.forComboRecusiveItemSelection(_):

  let priceStr = itemTotalPrice == 0 ? "" : "+£\(itemTotalPrice.getTwoDecimalPlacesString())  "
  lblDescription.text = priceStr + calorieStr

  }
  }
  */
 func modifireFlow(itemData1:ItemSelectedDetails,completion:(()->())? = nil){
 if selectedItem?.selectedCustomiser?.count ?? 0 > 0 {
 if let arrCustomize = selectedItem?.selectedCustomiser {
 let updatedCustomizeData = self.getCustomiseData(customiseData: arrCustomize)
 let resetCustomized = self.getCustomiseData(customiseData: itemData.modifiers?.customize  ?? [] )
 pushToCustomiseScreen(arrCustomise: updatedCustomizeData, arrResetMods: resetCustomized, isCustomise: true, screenType: .customise,completion: completion)
 }
 }

 if itemData1.parentItem?.isMultibox ?? false {
 let boxArray = itemData.box
 if boxArray?.count ?? 0 > 0 {
 let storyboard = UIStoryboard(name: "Order", bundle: nil)
 let detailVC = storyboard.instantiateViewController(withIdentifier: "CustmiseIngredientsViewController") as! CustmiseIngredientsViewController
 detailVC.arrItemDataModel = itemData
 detailVC.selectedItem = self.selectedItem
 //detailVC.arrCustmize = arrData
 //detailVC.isMultiBox  = true
 detailVC.isCustomise = true
 detailVC.screenType = .multibox
 detailVC.completion = completion
 self.show(detailVC, sender: self)
 }
 }
 }
 /*
  func getCustomiseData(customiseData: [Customize]?) -> [Customize] {
  let menuModuleObj = MenuModule()
  var arrDDC = menuModuleObj.getvalidModifires(_from: customiseData!) ?? [Customize]()

  for  modifire in arrDDC.enumerated() {
  let arrModireList = modifire.element.modifierList
  if arrModireList?.count ?? 0 > 0 {
  menuModuleObj.getModifireDetails(arrayModifire: arrModireList!) { modiredetails,errMsg in
  if !errMsg.isEmpty{
  self.showAlert(errorMessage: errMsg)
  return
  }
  if modiredetails?.count ?? 0 > 0 {
  let validMod = arrModireList?.filter({ modList in
  modiredetails!.contains(where: {$0.id == modList.modifier})
  })
  arrDDC[modifire.offset].modifierList = validMod
  arrDDC[modifire.offset].modifireDetails = modiredetails
  }
  }
  }

  }
  return arrDDC
  }
  */
 func pushToCustomiseScreen(arrCustomise: [Customize],arrResetMods: [Customize], isCustomise: Bool = true, screenType : EnumCustomiseScreenType,completion:(()->())? = nil) {
 let storyboard = UIStoryboard(name: "Order", bundle: nil)
 let detailVC = storyboard.instantiateViewController(withIdentifier: "CustmiseIngredientsViewController") as! CustmiseIngredientsViewController
 detailVC.arrCustmize = arrCustomise
 detailVC.arrCustmizeReset = arrResetMods
 detailVC.selectedItem = self.selectedItem //Class
 detailVC.isCustomise = isCustomise
 detailVC.screenType = screenType
 detailVC.completion = completion
 switch screenType {
 case .multibox:
 break
 case .customise:
 detailVC.arrItemDataModel = itemData
 if itemData.modifiers?.dipping?.count ?? 0 > 0 {
 if (itemData.modifiers?.dipping) != nil {
 let updatedDippingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? itemData.modifiers?.dipping)
 // detailVC.arrCustmizeDippingDressing = updatedDippingData
 }
 }
 else if itemData.modifiers?.dressing?.count ?? 0 > 0 {
 if (itemData.modifiers?.dressing) != nil {
 let updateddressingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? itemData.modifiers?.dressing)
 //   detailVC.arrCustmizeDippingDressing = updateddressingData
 }
 }
 case .dippingDressing:
 break

 }
 self.show(detailVC, sender: self)
 }

 func pushToDippingDressingScreen(completion:(()->())?) {
 if itemData.modifiers?.dipping?.count ?? 0 > 0 {
 if let dippingData = itemData.modifiers?.dipping {
 let updatedDippingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dippingData)
 let resetDippingData = self.getCustomiseData(customiseData: itemData.modifiers?.dipping ?? [])
 pushToCustomiseScreen(arrCustomise: updatedDippingData, arrResetMods: resetDippingData,isCustomise: false, screenType: .dippingDressing,completion: completion)
 }

 }
 else if itemData.modifiers?.dressing?.count ?? 0 > 0 {
 if let dressingData = itemData.modifiers?.dressing {
 let updateddressingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dressingData)
 let resetDressingData = self.getCustomiseData(customiseData: itemData.modifiers?.dressing ?? [])
 pushToCustomiseScreen(arrCustomise: updateddressingData, arrResetMods: resetDressingData,isCustomise: false, screenType: .dippingDressing,completion: completion)
 }
 }

 }

 func getUnAvailableModifire() {
 //        if itemData.modifiers?.dipping?.count ?? 0 > 0 {
 //            if let dippingData = itemData.modifiers?.dipping {
 //                let updatedDippingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dippingData)
 //                let resetDippingData = self.getCustomiseData(customiseData: itemData.modifiers?.dipping ?? [])
 //                //pushToCustomiseScreen(arrCustomise: updatedDippingData, arrResetMods: resetDippingData,isCustomise: false, screenType: .dippingDressing,completion: completion)
 //            }
 //
 //        }
 //        else if itemData.modifiers?.dressing?.count ?? 0 > 0 {
 //            if let dressingData = itemData.modifiers?.dressing {
 //                let updateddressingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dressingData)
 //                let resetDressingData = self.getCustomiseData(customiseData: itemData.modifiers?.dressing ?? [])
 //                //pushToCustomiseScreen(arrCustomise: updateddressingData, arrResetMods: resetDressingData,isCustomise: false, screenType: .dippingDressing,completion: completion)
 //            }
 //        }
 if selectedItem?.selectedCustomiser?.count ?? 0 > 0 {
 if var arrCustomize = selectedItem?.selectedCustomiser {
 let updatedCustomizeData = self.getCustomiseData(customiseData: arrCustomize)
 arrCustomize.indices.forEach { indexOf in
 var shrObj = arrCustomize[indexOf]
 if shrObj.isQuantifiable ?? false {

 shrObj.modifierList?.indices.forEach({ modifireIndex in

 var modifirelist = shrObj.modifierList![modifireIndex]

 if (modifirelist.defaultState == 1  && (modifirelist.minLimit ?? 0 > 0)) {

 let modifirelistData : ModifierListAPIData? = shrObj.modifireDetails?.first(where: { ($0.id ?? "") == modifirelist.modifier })

 if modifirelistData?.is_disable ?? false {
 // Some of the default Modifire is not available
 // disable item from menu
 Tbl_Menu_Item_List.updateToSetDisableItemsItems(isDisable: true, itemId: itemData.id ?? "", context: _coreDataShared.getContext(), completion: nil)
 self.btnAddToOrder.isEnabled = false
 }
 }
 else if (modifirelist.defaultState == 1) {
 let modifirelistData : ModifierListAPIData? = shrObj.modifireDetails?.first(where: { ($0.id ?? "") == (modifirelist.modifier ?? "")})
 if modifirelistData?.is_disable ?? false {
 // Some of the default Modifire is not available
 // make its default value ZERO
 shrObj.modifierList![modifireIndex].currentValue = 0
 arrCustomize[indexOf] = shrObj
 self.selectedItem?.selectedCustomiser = arrCustomize
 }
 }
 })

 }
 else {

 shrObj.modifierList?.indices.forEach({ modifireIndex in

 var modifirelist = shrObj.modifierList![modifireIndex]

 if (modifirelist.isSelected ?? false ) {

 let modifirelistData : ModifierListAPIData? = shrObj.modifireDetails?.first(where: { ($0.id ?? "") == modifirelist.modifier })

 if modifirelistData?.is_disable ?? false {
 // Some of the default Modifire is not available
 shrObj.modifierList![modifireIndex].currentValue = 0
 shrObj.modifierList![modifireIndex].isSelected = false
 arrCustomize[indexOf] = shrObj
 self.selectedItem?.selectedCustomiser = arrCustomize
 }
 }

 })
 }
 }
 }
 }

 if selectedItem?.allBoxItems?.count ?? 0  > 0 {
 _ = self.selectedItem?.allBoxItems?.enumerated().map({ boxItem in
 var shrObj = self.selectedItem?.allBoxItems![boxItem.offset]
 // shrObj?.modifiers.
 if shrObj?.is_disable ?? false{
 shrObj?.currentValue = 0
 shrObj?.chageIndefaultState = 0
 self.selectedItem?.allBoxItems![boxItem.offset] = shrObj!
 }


 })



 }
 }
 func showItemDetailsForMeal(itemData: ItemListData, varientType: String, bundleItem: BundleMealList) {
 let variantList  = itemData.variants ?? []
 var item_Price : Double = 0.0
 var defaultVariant : ItemListDatumVariant?
 if variantList.count > 0 {
 variantList.forEach { variantDetails in
 if varientType ==  variantDetails.variantType {
 item_Price = 0.0
 defaultVariant = variantDetails
 }
 else {

 item_Price = Global.getPriceForItem(price: variantDetails.upchargePrice ?? 0, arrayPromoptionPrice: itemData.mealUpchargePrice ?? []) ?? 0
 }
 }

 if defaultVariant == nil {
 //If no any default Variant then find lowest upcharge price.
 let price = variantList.min(by: { obj1, obj2 in
 obj1.upchargePrice ?? 0 < obj2.upchargePrice ?? 0
 })
 defaultVariant = price
 }
 }
 else {

 item_Price = Global.getPriceForItem(price: itemData.meals?.first?.price ?? 0, arrayPromoptionPrice: itemData.meals?.first?.promotionPrice ?? []) ?? 0
 }

 lblTitle.text = itemData.title

 if itemData.price != 0 {
 lblDescription.text = "\(item_Price) \(Global.singleton.returnCalaroisCalculation(calaories: itemData.calorie ?? 0, quantity: 1))"
 }

 if itemData.calorie ?? 0 != 0 {
 lblDescription.text = Global.singleton.returnCalaroisCalculation(calaories: itemData.calorie ?? 0, quantity: 1)
 }
 else {
 lblDescription.text = ""
 }
 }
 private func addOfferSelectedItem(offerModel:OffersModel) -> OffersModel{
 var offersModel = offerModel
 if let currentItemFromEntityGroup = self.itemData.parentOfferEntityGroupDetails{
 if let itemFrom = currentItemFromEntityGroup.itemFrom{
 var entityType = ""

 // SET DEFAULT BOX ITEM DATA
 setBoxItemsDefaultItemsNotChange()

 let offerSubItemObj = OfferSubItem(
 strSelectedEntityId: self.itemData.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.getItemName(selectedVariant: self.selectedItem?.selectedVarient),
 Quentity: Int(thStepper?.value ?? 0),
 PricePerItem: self.pricePerItem,
 Price: self.pricePerItem * (thStepper?.value ?? 0),
 sumOfMod: self.sumOfMods,
 selectedVarient: self.selectedItem?.selectedVarient,
 selectedDressingDipping: self.selectedItem?.selectedDressingDipping,
 selectedBoxItems: self.selectedItem?.selectedBoxItem,
 itemType: self.itemData.itemType)

 switch itemFrom {
 case .rule:
 let entityGroup =  offersModel.discount_rule?.entity_groups?.first(where: {$0._id == currentItemFromEntityGroup.entity_group_id})
 entityType = entityGroup?.entity_type ?? EnumEntityType.item.rawValue

 let action_type = entityGroup?.action_type ?? .item

 if let currentDataFromBundleIndex = offersModel.selected_items?.firstIndex(where: {$0.entity_group_id == currentItemFromEntityGroup.entity_group_id}){
 var tempItems = offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems ?? []

 switch action_type{
 case .item:
 tempItems.append(OfferItems(quantity: offerSubItemObj.Quentity ?? 1, offerItem: .item(offerSubItemObj), replacebleQty: offerSubItemObj.Quentity ?? 1, cart_item_id: ""))
 //tempItems.append(OfferItems(quantity: offerSubItemObj.Quentity ?? 1, offerItem: .item(offerSubItemObj), discountFromApplyGroupId: currentItemFromEntityGroup.entity_group_id ?? "", cart_item_id: ""))
 case .meal:
 if let mealModificationData = mealModificationData{
 tempItems.append(OfferItems(quantity: mealModificationData.Quentity ?? 1, offerItem: .mealAsSubItem(mealModificationData), replacebleQty: mealModificationData.Quentity ?? 1, cart_item_id: ""))
 //tempItems.append(OfferItems(quantity: mealModificationData.Quentity ?? 1, offerItem: .mealAsSubItem(mealModificationData), discountFromApplyGroupId: currentItemFromEntityGroup.entity_group_id ?? "", cart_item_id: ""))
 }
 }

 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems = tempItems
 }


 case .apply:
 if let entityGroup =  offersModel.discount_apply?.entity_groups?.first(where: {$0.id == currentItemFromEntityGroup.entity_group_id}){

 entityType = entityGroup.entity_type ?? EnumEntityType.item.rawValue

 let action_type = entityGroup.action_type ?? .item

 if let currentDataFromBundleIndex = offersModel.selected_items?.firstIndex(where: {$0.entity_group_id == currentItemFromEntityGroup.entity_group_id}){
 var tempItems = offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems ?? []

 switch action_type {
 case .item:
 tempItems.append(OfferItems(quantity: offerSubItemObj.Quentity ?? 1, offerItem: .item(offerSubItemObj), replacebleQty: offerSubItemObj.Quentity ?? 1, cart_item_id: ""))
 // tempItems.append(OfferItems(quantity: offerSubItemObj.Quentity ?? 1, offerItem: .item(offerSubItemObj), discountFromApplyGroupId: currentItemFromEntityGroup.entity_group_id ?? "", cart_item_id: ""))
 case .meal:
 if let mealModificationData = mealModificationData{
 tempItems.append(OfferItems(quantity: mealModificationData.Quentity ?? 1, offerItem: .mealAsSubItem(mealModificationData), replacebleQty: mealModificationData.Quentity ?? 1, cart_item_id: ""))
 //   tempItems.append(OfferItems(quantity: mealModificationData.Quentity ?? 1, offerItem: .mealAsSubItem(mealModificationData), discountFromApplyGroupId: currentItemFromEntityGroup.entity_group_id ?? "", cart_item_id: ""))
 }
 }
 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems = tempItems

 }
 }
 }
 }
 }
 return offersModel
 }
 private func handleSelectedItemForOfferEntity(){
 switch itemDetailScreenType {
 case .forCartAddFromLoyalityWithOffers(var offersModel):
 offersModel = addOfferSelectedItem(offerModel: offersModel)
 self.offerItemSelectionCompletion?(offersModel)

 case .forEditOfferItemCustomiser(var offersModel,let offerSubItem,let editedIndex),.forChangeOfferItem(var offersModel,let offerSubItem,let editedIndex):
 if let type = offerSubItem.type{

 // SET DEFAULT BOX ITEM DATA
 setBoxItemsDefaultItemsNotChange()

 let offerSubItemObj = OfferSubItem(
 strSelectedEntityId: self.itemData.id,
 arrEntityCustomise: selectedItem?.selectedCustomiser,
 itemTitle: itemData.getItemName(selectedVariant: self.selectedItem?.selectedVarient),
 Quentity: Int(thStepper?.value ?? 0),
 PricePerItem: self.pricePerItem,
 Price: self.pricePerItem * (thStepper?.value ?? 0),
 sumOfMod: self.sumOfMods,
 selectedVarient: self.selectedItem?.selectedVarient,
 selectedDressingDipping: self.selectedItem?.selectedDressingDipping,
 selectedBoxItems: self.selectedItem?.selectedBoxItem,
 itemType: self.itemData.itemType)

 switch type {
 case .rule:
 let entityGroup =  offersModel.discount_rule?.entity_groups?.first(where: {$0._id == offerSubItem.entity_group_id})

 let action_type = entityGroup?.action_type ?? .item

 if let currentDataFromBundleIndex = offersModel.selected_items?.firstIndex(where: {$0.entity_group_id == offerSubItem.entity_group_id}){


 switch action_type{
 case .item:
 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].offerItem = .item(offerSubItemObj)
 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].quantity = offerSubItemObj.Quentity ?? 0
 case .meal:
 if let mealModificationData = mealModificationData{

 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].offerItem = .mealAsSubItem(mealModificationData)
 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].quantity = mealModificationData.Quentity ?? 0
 }
 }

 self.offerItemSelectionCompletion?(offersModel)
 }

 case .apply:
 if let entityGroup =  offersModel.discount_apply?.entity_groups?.first(where: {$0.id == offerSubItem.entity_group_id}){

 let action_type = entityGroup.action_type ?? .item

 if let currentDataFromBundleIndex = offersModel.selected_items?.firstIndex(where: {$0.entity_group_id == offerSubItem.entity_group_id}){

 switch action_type {
 case .item:
 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].offerItem = .item(offerSubItemObj)
 case .meal:
 if let mealModificationData = mealModificationData{

 offersModel.selected_items?[currentDataFromBundleIndex].arrOfferItems?[editedIndex].offerItem = .mealAsSubItem(mealModificationData)
 }
 }

 self.offerItemSelectionCompletion?(offersModel)
 }
 }
 }
 }
 break
 default:
 break
 }
 }
 }

 extension ItemDetailsViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return selectedItem?.varientData?.count ?? 0
 }

 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollCellVarient.identifible, for: indexPath) as? CollCellVarient else {return UICollectionViewCell()}
 let varientData = selectedItem?.varientData![indexPath.row]
 cell.lblTitle.text = (varientData?.varientType?.name ?? "") + " \(itemData.name ?? "")"
 cell.lblPrefix.text = varientData?.varientType?.title
 let myString = varientData?.varientType?.title
 if let myString = myString {
 if myString.count > 0 {
 cell.lblPrefix.text = String(myString.prefix(1))
 }
 }

 cell.lblUnavailable.isHidden = !(varientData?.varientType?.is_disable ?? false)
 cell.vwPrefix.backgroundColor = cell.lblUnavailable.isHidden ? .clear : .lightGray.withAlphaComponent(0.4)

 switch itemDetailScreenType {
 case .forCartAdd,.editCartItem(_),.forMealRootCustomiserChange(_),.forCartAddFromLoyalityWithBooster(_),.editBoosterItem(_),.forComboItemChange(_),.forComboItemSelection,.forComboMealAdd,.forComboEditSubItemCustomiser(_,_),.forComboRecusiveItemSelection(_),.forCartAddFromLoyalityWithOffers(_),.forChangeOfferItem(_, _, _),.forEditOfferItemCustomiser(_, _, _),.forComboAddFromReviewScreen:
 cell.lblPriceInclude.isHidden = true

 case .forMealItemSelection, .forMealEditCustomiser(_),.forMealItemChange:
 cell.lblPriceInclude.text = varientData?.getPriceCalMealString(freeVarientId: mealDrinkBundleEntity?.variantType ?? [], mealID: self.mealModificationData?.strMealId ?? "")
 cell.lblPriceInclude.isHidden = false
 break
 }

 if (varientData?.varientType?.is_disable ?? false) {
 cell.lblTitle.textColor = ThemeColors.gray.getColor
 cell.isUserInteractionEnabled = false
 }
 else {
 cell.lblTitle.textColor = .black
 cell.isUserInteractionEnabled = true
 }
 var borderColor = UIColor.lightGray.cgColor
 if !(varientData?.varientType?.is_disable ?? false) {
 if let selectedVarient = selectedItem?.selectedVarient {
 if let id = selectedItem?.varientData?[indexPath.row].varientParentData?.variantType,id == selectedVarient.variantType!{
 borderColor = ThemeColors.red.getColor.cgColor
 thStepper?.alpha = 1
 thStepper?.isUserInteractionEnabled = true
 btnCustmise.alpha = 1
 btnCustmise.isUserInteractionEnabled = true

 if self.isShowDippingDressing{
 let cell = self.tblMealItems.cellForRow(at: IndexPath(row: 0, section: 0)) as! CellDressingDeeping
 cell.vwBorder.alpha = 1
 self.tblMealItems.allowsSelection = true
 }
 }
 }
 }

 cell.lblPrefix.textColor        = UIColor(cgColor: borderColor)
 cell.vwPrefix.layer.borderColor = borderColor

 return cell
 }
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 // NEED TO UPDATE HEIGHT FOR COLLETION WHEN DATA IS UPDATED
 return CGSize(width: (collectionView.bounds.width - 20) /  3, height: collectionView.bounds.height)
 }

 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

 //Where elements_count is the count of all your items in that
 //Collection view...
 let cellCount = CGFloat(selectedItem?.varientData?.count ?? 0)

 //If the cell count is zero, there is no point in calculating anything.
 if cellCount > 0 {
 let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
 let cellWidth = (collectionView.bounds.width - 20) /  3

 //20.00 was just extra spacing I wanted to add to my cell.
 let totalCellWidth = cellWidth*cellCount + 10 * (cellCount-1)
 let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

 if (totalCellWidth < contentWidth) {
 //If the number of cells that exists take up less room than the
 //collection view width... then there is an actual point to centering them.

 //Calculate the right amount of padding to center the cells.
 let padding = (contentWidth - totalCellWidth) / 2
 return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
 } else {
 //Pretty much if the number of cells that exist take up
 //more room than the actual collectionView width, there is no
 // point in trying to center them. So we leave the default behavior.
 return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
 }
 }
 return UIEdgeInsets.zero
 }

 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

 let varientData = selectedItem?.varientData![indexPath.row]
 if !(varientData?.varientType?.is_disable ?? false) {
 lblTitle.text = "\(selectedItem!.varientData?[indexPath.row].varientType!.name ?? "") \(itemData.title ?? "")"
 selectedItem?.selectedVarient = selectedItem!.varientData?[indexPath.row].varientParentData
 imgItem.imageURL(selectedItem?.selectedVarient?.image ?? "", compltion: nil)
 setNutritionBtnVisiblity()
 setUpdatedPrice()
 collectionView.reloadData()
 }
 else {
 return
 }
 }
 }

 extension ItemDetailsViewController:UITableViewDelegate,UITableViewDataSource{
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 return isShowDippingDressing ? 1 : 0
 }

 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 guard let cell = tableView.dequeueReusableCell(withIdentifier: CellDressingDeeping.identifire, for: indexPath) as? CellDressingDeeping else {return UITableViewCell()}
 let dippingDressing  = handleDippingDressing().first
 if strSelectedDressingDipping.last == ","{
 strSelectedDressingDipping.removeLast()
 }
 if !strSelectedDressingDipping.isEmpty{
 strSelectedDressingDipping = "\n" + strSelectedDressingDipping
 }
 cell.lblTitle.text = "Select a \(String(describing: dippingDressing?.modifierCategory ?? "")) for \(String(describing: lblTitle.text ?? "")) \(strSelectedDressingDipping)"
 return cell
 }

 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 //        if selectedItem?.selectedDressingDipping?.count ?? 0 > 0 {
 //            if let dressingData = itemData.modifiers?.dressing {
 //                let updateddressingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping)
 //                let resetDressingData = self.getCustomiseData(customiseData: itemData.modifiers?.dressing ?? [])
 //                pushToCustomiseScreen(arrCustomise: updateddressingData, arrResetMods: resetDressingData,isCustomise: false)
 //            }
 //        }
 //        else {
 if itemData.modifiers?.dipping?.count ?? 0 > 0 {
 if let dippingData = itemData.modifiers?.dipping {
 let updatedDippingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dippingData)
 let resetDippingData = self.getCustomiseData(customiseData: itemData.modifiers?.dipping ?? [])
 pushToCustomiseScreen(arrCustomise: updatedDippingData, arrResetMods: resetDippingData,isCustomise: false, screenType: .dippingDressing)
 }

 }
 else if itemData.modifiers?.dressing?.count ?? 0 > 0 {
 if let dressingData = itemData.modifiers?.dressing {
 let updateddressingData = self.getCustomiseData(customiseData: selectedItem?.selectedDressingDipping ?? dressingData)
 let resetDressingData = self.getCustomiseData(customiseData: itemData.modifiers?.dressing ?? [])
 pushToCustomiseScreen(arrCustomise: updateddressingData, arrResetMods: resetDressingData,isCustomise: false, screenType: .dippingDressing)
 }
 }
 }
 }
 */
