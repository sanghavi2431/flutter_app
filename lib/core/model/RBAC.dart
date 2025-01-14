class RBAC {
  RBAC({
    this.homeScreen,
    this.marketsScreen,
    this.productsScreen,
    this.managersScreen,
    this.membersScreen,
    this.subscriptionScreen,
  });

  RBAC.fromJson(dynamic json) {
    homeScreen = json['homeScreen'] != null
        ? HomeScreen.fromJson(json['homeScreen'])
        : null;
    marketsScreen = json['marketsScreen'] != null
        ? MarketsScreen.fromJson(json['marketsScreen'])
        : null;
    productsScreen = json['productsScreen'] != null
        ? ProductsScreen.fromJson(json['productsScreen'])
        : null;
    managersScreen = json['managersScreen'] != null
        ? ManagersScreen.fromJson(json['managersScreen'])
        : null;
    membersScreen = json['membersScreen'] != null
        ? MembersScreen.fromJson(json['membersScreen'])
        : null;
    subscriptionScreen = json['subscriptionScreen'] != null
        ? SubscriptionScreen.fromJson(json['subscriptionScreen'])
        : null;
  }

  HomeScreen? homeScreen;
  MarketsScreen? marketsScreen;
  ProductsScreen? productsScreen;
  ManagersScreen? managersScreen;
  MembersScreen? membersScreen;
  SubscriptionScreen? subscriptionScreen;
}

class MembersScreen {
  MembersScreen.fromJson(dynamic json) {
    add = json['Add'] != null
        ? Template.fromJson(json['Add'])
        : Template(enabled: false);
    edit = json['Edit'] != null
        ? Template.fromJson(json['Edit'])
        : Template(enabled: false);
    delete = json['Delete'] != null
        ? Template.fromJson(json['Delete'])
        : Template(enabled: false);
    approve = json['Approve'] != null
        ? Template.fromJson(json['Approve'])
        : Template(enabled: false);
    mapToMarket = json['AddMappedMarket'] != null
        ? Template.fromJson(json['AddMappedMarket'])
        : Template(enabled: false);
  }

  Template? add;
  Template? edit;
  Template? delete;
  Template? approve;
  Template? mapToMarket;
}

class SubscriptionScreen {
  SubscriptionScreen.fromJson(dynamic json) {
    subscribe = json['Subscribe'] != null
        ? Template.fromJson(json['Subscribe'])
        : Template(enabled: false);
  }

  Template? subscribe;
}

class ManagersScreen {
  ManagersScreen.fromJson(dynamic json) {
    add = json['Add'] != null
        ? Template.fromJson(json['Add'])
        : Template(enabled: false);
    edit = json['Edit'] != null
        ? Template.fromJson(json['Edit'])
        : Template(enabled: false);
    delete = json['Delete'] != null
        ? Template.fromJson(json['Delete'])
        : Template(enabled: false);
    approve = json['Approve'] != null
        ? Template.fromJson(json['Approve'])
        : Template(enabled: false);
    mapToMarket = json['AddMappedMarket'] != null
        ? Template.fromJson(json['AddMappedMarket'])
        : Template(enabled: false);
  }

  Template? add;
  Template? edit;
  Template? delete;
  Template? approve;
  Template? mapToMarket;
}

class ProductsScreen {
  ProductsScreen.fromJson(dynamic json) {
    add = json['Add'] != null
        ? Template.fromJson(json['Add'])
        : Template(enabled: false);
    edit = json['Edit'] != null
        ? Template.fromJson(json['Edit'])
        : Template(enabled: false);
    delete = json['Delete'] != null
        ? Template.fromJson(json['Delete'])
        : Template(enabled: false);
    mapToMarket = json['AddMappedMarket'] != null
        ? Template.fromJson(json['AddMappedMarket'])
        : Template(enabled: false);
  }

  Template? add;
  Template? edit;
  Template? delete;
  Template? mapToMarket;
}

class MarketsScreen {
  MarketsScreen.fromJson(dynamic json) {
    add = json['Add'] != null
        ? Template.fromJson(json['Add'])
        : Template(enabled: false);
    edit = json['Edit'] != null
        ? Template.fromJson(json['Edit'])
        : Template(enabled: false);
    delete = json['Delete'] != null
        ? Template.fromJson(json['Delete'])
        : Template(enabled: false);
    viewMappedProducts = json['ViewMappedProducts'] != null
        ? Template.fromJson(json['ViewMappedProducts'])
        : Template(enabled: false);
    viewMappedManagers = json['ViewMappedManagers'] != null
        ? Template.fromJson(json['ViewMappedManagers'])
        : Template(enabled: false);
    viewMappedMember = json['ViewMappedMember'] != null
        ? Template.fromJson(json['ViewMappedMember'])
        : Template(enabled: false);
  }
  Template? add;
  Template? edit;
  Template? delete;
  Template? viewMappedProducts;
  Template? viewMappedManagers;
  Template? viewMappedMember;
}

class HomeScreen {
  HomeScreen.fromJson(dynamic json) {
    markets = json['Markets'] != null
        ? Template.fromJson(json['Markets'])
        : Template(enabled: false);
    products = json['Products'] != null
        ? Template.fromJson(json['Products'])
        : Template(enabled: false);
    managers = json['Managers'] != null
        ? Template.fromJson(json['Managers'])
        : Template(enabled: false);
    members = json['Members'] != null
        ? Template.fromJson(json['Members'])
        : Template(enabled: false);
    subscription = json['Subscription'] != null
        ? Template.fromJson(json['Subscription'])
        : Template(enabled: false);
  }

  Template? markets;
  Template? products;
  Template? managers;
  Template? members;
  Template? subscription;
}

class Template {
  Template({
    this.enabled,
  });

  Template.fromJson(dynamic json) {
    enabled = json['enabled'];
  }

  bool? enabled;
}
