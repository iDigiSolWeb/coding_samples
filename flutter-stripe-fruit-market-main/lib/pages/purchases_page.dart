

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({Key? key}) : super(key: key);

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: PurchaseService(authService: AuthService())
          .fetchCurrentCustomerPurchasedProducts(),
      builder: (context, snapshot) {
        return BaseView(
            title: 'Purchases',
            isLoading: !snapshot.hasData,
            child: snapshot.hasData
                ? GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: snapshot.data![index],
                        showPurchase: false,
                      );
                    },
                  )
                : Container());
      },
    );
  }
}
