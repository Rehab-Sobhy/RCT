// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during login`
  String get loginError {
    return Intl.message(
      'An error occurred during login',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image`
  String get chooseImage {
    return Intl.message(
      'Choose Image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Have an account?`
  String get haveAccount {
    return Intl.message(
      'Have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Edit File`
  String get editFile {
    return Intl.message(
      'Edit File',
      name: 'editFile',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Calculator & Projects`
  String get calculatorProjects {
    return Intl.message(
      'Calculator & Projects',
      name: 'calculatorProjects',
      desc: '',
      args: [],
    );
  }

  /// `Approximate cost details and fees:`
  String get approximateCostDetails {
    return Intl.message(
      'Approximate cost details and fees:',
      name: 'approximateCostDetails',
      desc: '',
      args: [],
    );
  }

  /// `Construction + Consultation + Plans + Insurance + Fence and tank works + Sanitation + Excavation and backfilling + Removal and transport. All products used are of high quality with necessary guarantees provided.`
  String get constructionConsultationPlansInsurance {
    return Intl.message(
      'Construction + Consultation + Plans + Insurance + Fence and tank works + Sanitation + Excavation and backfilling + Removal and transport. All products used are of high quality with necessary guarantees provided.',
      name: 'constructionConsultationPlansInsurance',
      desc: '',
      args: [],
    );
  }

  /// `Plans & Designs`
  String get plansDesigns {
    return Intl.message(
      'Plans & Designs',
      name: 'plansDesigns',
      desc: '',
      args: [],
    );
  }

  /// `Success Partners`
  String get successPartners {
    return Intl.message(
      'Success Partners',
      name: 'successPartners',
      desc: '',
      args: [],
    );
  }

  /// `Total Land Area`
  String get totalLandArea {
    return Intl.message(
      'Total Land Area',
      name: 'totalLandArea',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the total area`
  String get pleaseEnterTotalArea {
    return Intl.message(
      'Please enter the total area',
      name: 'pleaseEnterTotalArea',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again`
  String get errorPleaseTryAgain {
    return Intl.message(
      'An error occurred, please try again',
      name: 'errorPleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the required information`
  String get pleaseEnterRequiredInformation {
    return Intl.message(
      'Please enter the required information',
      name: 'pleaseEnterRequiredInformation',
      desc: '',
      args: [],
    );
  }

  /// `Building Mechanism`
  String get buildingMechanism {
    return Intl.message(
      'Building Mechanism',
      name: 'buildingMechanism',
      desc: '',
      args: [],
    );
  }

  /// `Choose Type`
  String get chooseType {
    return Intl.message(
      'Choose Type',
      name: 'chooseType',
      desc: '',
      args: [],
    );
  }

  /// `Residential Complex`
  String get residentialComplex {
    return Intl.message(
      'Residential Complex',
      name: 'residentialComplex',
      desc: '',
      args: [],
    );
  }

  /// `Number of Floors`
  String get numberOfFloors {
    return Intl.message(
      'Number of Floors',
      name: 'numberOfFloors',
      desc: '',
      args: [],
    );
  }

  /// `Enter Number of Floors`
  String get enterNumberOfFloors {
    return Intl.message(
      'Enter Number of Floors',
      name: 'enterNumberOfFloors',
      desc: '',
      args: [],
    );
  }

  /// `Number of Apartments`
  String get numberOfApartments {
    return Intl.message(
      'Number of Apartments',
      name: 'numberOfApartments',
      desc: '',
      args: [],
    );
  }

  /// `Enter Number of Apartments`
  String get enterNumberOfApartments {
    return Intl.message(
      'Enter Number of Apartments',
      name: 'enterNumberOfApartments',
      desc: '',
      args: [],
    );
  }

  /// `Request sent successfully`
  String get requestSentSuccessfully {
    return Intl.message(
      'Request sent successfully',
      name: 'requestSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The request will be reviewed soon, you can check the notifications`
  String get requestWillBeReviewed {
    return Intl.message(
      'The request will be reviewed soon, you can check the notifications',
      name: 'requestWillBeReviewed',
      desc: '',
      args: [],
    );
  }

  /// `National ID or Commercial Register *`
  String get nationalIdOrCommercialRegister {
    return Intl.message(
      'National ID or Commercial Register *',
      name: 'nationalIdOrCommercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Electronic Deed *`
  String get electronicDeed {
    return Intl.message(
      'Electronic Deed *',
      name: 'electronicDeed',
      desc: '',
      args: [],
    );
  }

  /// `Add Soil Test Report `
  String get addSoilTestReport {
    return Intl.message(
      'Add Soil Test Report ',
      name: 'addSoilTestReport',
      desc: '',
      args: [],
    );
  }

  /// `If not available, there will be an additional cost of 2000 SAR`
  String get additionalCostIfNotAvailable {
    return Intl.message(
      'If not available, there will be an additional cost of 2000 SAR',
      name: 'additionalCostIfNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Property Location`
  String get propertyLocation {
    return Intl.message(
      'Property Location',
      name: 'propertyLocation',
      desc: '',
      args: [],
    );
  }

  /// `Or enter the site link`
  String get enterSiteLink {
    return Intl.message(
      'Or enter the site link',
      name: 'enterSiteLink',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Request`
  String get cancelRequest {
    return Intl.message(
      'Cancel Request',
      name: 'cancelRequest',
      desc: '',
      args: [],
    );
  }

  /// `Reply sent successfully`
  String get replySentSuccessfully {
    return Intl.message(
      'Reply sent successfully',
      name: 'replySentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `You will receive a notification about payment`
  String get paymentNotification {
    return Intl.message(
      'You will receive a notification about payment',
      name: 'paymentNotification',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `The request will be canceled, are you sure you want to cancel?`
  String get cancelRequestConfirmation {
    return Intl.message(
      'The request will be canceled, are you sure you want to cancel?',
      name: 'cancelRequestConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message(
      'Reject',
      name: 'reject',
      desc: '',
      args: [],
    );
  }

  /// `Type of Building`
  String get typeOfBuilding {
    return Intl.message(
      'Type of Building',
      name: 'typeOfBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Total Cost of the Project`
  String get totalProjectCost {
    return Intl.message(
      'Total Cost of the Project',
      name: 'totalProjectCost',
      desc: '',
      args: [],
    );
  }

  /// `Agree to the terms and conditions to view`
  String get agreeToTermsAndConditions {
    return Intl.message(
      'Agree to the terms and conditions to view',
      name: 'agreeToTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Please choose the design or plan`
  String get pleaseChooseDesignOrPlan {
    return Intl.message(
      'Please choose the design or plan',
      name: 'pleaseChooseDesignOrPlan',
      desc: '',
      args: [],
    );
  }

  /// `Other details or information`
  String get otherDetailsOrInformation {
    return Intl.message(
      'Other details or information',
      name: 'otherDetailsOrInformation',
      desc: '',
      args: [],
    );
  }

  /// `Please write any other details`
  String get pleaseWriteOtherDetails {
    return Intl.message(
      'Please write any other details',
      name: 'pleaseWriteOtherDetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter request number`
  String get enterRequestNumber {
    return Intl.message(
      'Enter request number',
      name: 'enterRequestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please choose request number`
  String get pleaseChooseRequestNumber {
    return Intl.message(
      'Please choose request number',
      name: 'pleaseChooseRequestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Submit request`
  String get submitRequest {
    return Intl.message(
      'Submit request',
      name: 'submitRequest',
      desc: '',
      args: [],
    );
  }

  /// `No requests`
  String get noRequests {
    return Intl.message(
      'No requests',
      name: 'noRequests',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Plans`
  String get plans {
    return Intl.message(
      'Plans',
      name: 'plans',
      desc: '',
      args: [],
    );
  }

  /// `Designs`
  String get designs {
    return Intl.message(
      'Designs',
      name: 'designs',
      desc: '',
      args: [],
    );
  }

  /// `Custom Plans and Designs`
  String get customPlansAndDesigns {
    return Intl.message(
      'Custom Plans and Designs',
      name: 'customPlansAndDesigns',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during loading, please try again`
  String get loadingError {
    return Intl.message(
      'An error occurred during loading, please try again',
      name: 'loadingError',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get noNotifications {
    return Intl.message(
      'No notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Expires in 3 days`
  String get expiresIn3Days {
    return Intl.message(
      'Expires in 3 days',
      name: 'expiresIn3Days',
      desc: '',
      args: [],
    );
  }

  /// `Attach Transfer Receipt`
  String get attachTransferReceipt {
    return Intl.message(
      'Attach Transfer Receipt',
      name: 'attachTransferReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed Abdullah`
  String get ahmedAbdullah {
    return Intl.message(
      'Ahmed Abdullah',
      name: 'ahmedAbdullah',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message(
      'SAR',
      name: 'sar',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `We build your dreams and make them reality`
  String get page1Title {
    return Intl.message(
      'We build your dreams and make them reality',
      name: 'page1Title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get page1Description {
    return Intl.message(
      '',
      name: 'page1Description',
      desc: '',
      args: [],
    );
  }

  /// `You want to build and want a trusted source`
  String get page2Title {
    return Intl.message(
      'You want to build and want a trusted source',
      name: 'page2Title',
      desc: '',
      args: [],
    );
  }

  /// `We provide you with everything you need to build with the best specifications and measurements. Just register in the system and choose what suits you, and we'll handle the rest.`
  String get page2Description {
    return Intl.message(
      'We provide you with everything you need to build with the best specifications and measurements. Just register in the system and choose what suits you, and we\'ll handle the rest.',
      name: 'page2Description',
      desc: '',
      args: [],
    );
  }

  /// `You have property but no liquidity`
  String get page3Title {
    return Intl.message(
      'You have property but no liquidity',
      name: 'page3Title',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry, we build for you, and you pay us after two years without any interest or hidden fees.`
  String get page3Description {
    return Intl.message(
      'Don\'t worry, we build for you, and you pay us after two years without any interest or hidden fees.',
      name: 'page3Description',
      desc: '',
      args: [],
    );
  }

  /// `Our Application`
  String get page4Title {
    return Intl.message(
      'Our Application',
      name: 'page4Title',
      desc: '',
      args: [],
    );
  }

  /// `Through the application, you can calculate costs, choose the designs you want, and submit the request with ease and simplicity.`
  String get page4Description {
    return Intl.message(
      'Through the application, you can calculate costs, choose the designs you want, and submit the request with ease and simplicity.',
      name: 'page4Description',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Real Estates Offers`
  String get realestate {
    return Intl.message(
      'Real Estates Offers',
      name: 'realestate',
      desc: '',
      args: [],
    );
  }

  /// `Please complete sections`
  String get completeMessage {
    return Intl.message(
      'Please complete sections',
      name: 'completeMessage',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Enter district name`
  String get enterDistrict {
    return Intl.message(
      'Enter district name',
      name: 'enterDistrict',
      desc: '',
      args: [],
    );
  }

  /// ` Choose City`
  String get chooseCity {
    return Intl.message(
      ' Choose City',
      name: 'chooseCity',
      desc: '',
      args: [],
    );
  }

  /// `Filtering`
  String get filter {
    return Intl.message(
      'Filtering',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Main Photo `
  String get mainPhoto {
    return Intl.message(
      'Main Photo ',
      name: 'mainPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Section Photos `
  String get sectionPhotos {
    return Intl.message(
      'Section Photos ',
      name: 'sectionPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Add Estate `
  String get addEstate {
    return Intl.message(
      'Add Estate ',
      name: 'addEstate',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Write a summary about Estate `
  String get estateSummary {
    return Intl.message(
      'Write a summary about Estate ',
      name: 'estateSummary',
      desc: '',
      args: [],
    );
  }

  /// `Estate Type `
  String get estateType {
    return Intl.message(
      'Estate Type ',
      name: 'estateType',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Space`
  String get space {
    return Intl.message(
      'Space',
      name: 'space',
      desc: '',
      args: [],
    );
  }

  /// `Residential`
  String get residential {
    return Intl.message(
      'Residential',
      name: 'residential',
      desc: '',
      args: [],
    );
  }

  /// `Commercial`
  String get commercial {
    return Intl.message(
      'Commercial',
      name: 'commercial',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get discreption {
    return Intl.message(
      'Description',
      name: 'discreption',
      desc: '',
      args: [],
    );
  }

  /// `ReFilter`
  String get refilter {
    return Intl.message(
      'ReFilter',
      name: 'refilter',
      desc: '',
      args: [],
    );
  }

  /// `Don't Found`
  String get dontFound {
    return Intl.message(
      'Don\'t Found',
      name: 'dontFound',
      desc: '',
      args: [],
    );
  }

  /// `House Name`
  String get estateName {
    return Intl.message(
      'House Name',
      name: 'estateName',
      desc: '',
      args: [],
    );
  }

  /// `Cooperation and Partnership`
  String get cooperationAndPartnership {
    return Intl.message(
      'Cooperation and Partnership',
      name: 'cooperationAndPartnership',
      desc: '',
      args: [],
    );
  }

  /// ` Complete Request`
  String get completeRequest {
    return Intl.message(
      ' Complete Request',
      name: 'completeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Real Estate Orders`
  String get realEstateOrders {
    return Intl.message(
      'Real Estate Orders',
      name: 'realEstateOrders',
      desc: '',
      args: [],
    );
  }

  /// `Calculator& Projects Orders`
  String get calculatorAndProjectsOrders {
    return Intl.message(
      'Calculator& Projects Orders',
      name: 'calculatorAndProjectsOrders',
      desc: '',
      args: [],
    );
  }

  /// `Cooperation & Partenership Orders`
  String get cooperationAndPartenershipOrders {
    return Intl.message(
      'Cooperation & Partenership Orders',
      name: 'cooperationAndPartenershipOrders',
      desc: '',
      args: [],
    );
  }

  /// `OldBuildings Orders`
  String get oldBuildingsOrders {
    return Intl.message(
      'OldBuildings Orders',
      name: 'oldBuildingsOrders',
      desc: '',
      args: [],
    );
  }

  /// `RawLands Orders`
  String get rawLandsOrders {
    return Intl.message(
      'RawLands Orders',
      name: 'rawLandsOrders',
      desc: '',
      args: [],
    );
  }

  /// ` schema Orders`
  String get schemaOrders {
    return Intl.message(
      ' schema Orders',
      name: 'schemaOrders',
      desc: '',
      args: [],
    );
  }

  /// `Move to payment`
  String get payment {
    return Intl.message(
      'Move to payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirmlocation {
    return Intl.message(
      'Confirm Location',
      name: 'confirmlocation',
      desc: '',
      args: [],
    );
  }

  /// `Add Pool`
  String get addpool {
    return Intl.message(
      'Add Pool',
      name: 'addpool',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favourite {
    return Intl.message(
      'Favorites',
      name: 'favourite',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
