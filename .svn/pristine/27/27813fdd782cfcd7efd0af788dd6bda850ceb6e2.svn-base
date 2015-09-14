

#import "EBPurchase.h"
#import "NetLoadingWaitView.h"

@implementation EBPurchase

@synthesize delegate;
@synthesize validProduct;
@synthesize orderListNumber = _orderListNumber;

- (id)init {

  if (self = [super init]) {
    showMessage = [[UIAlertView alloc] initWithTitle:@"正在提交订单..."
                                             message:nil
                                            delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil, nil];
    activeView = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  }
  return self;
}

- (bool)requestProduct:(NSArray *)productIdArray {

  if (productIdArray != nil && [productIdArray count] > 0) {

    NSLog(@"EBPurchase requestProduct: %@", productIdArray);

    if ([SKPaymentQueue canMakePayments]) {
      // Yes, In-App Purchase is enabled on this device.
      // Proceed to fetch available In-App Purchase items.

      // Initiate a product request of the Product ID.
      SKProductsRequest *prodRequest = [[SKProductsRequest alloc]
          initWithProductIdentifiers:[NSSet setWithArray:productIdArray]];
      prodRequest.delegate = self;
      [prodRequest start];
      [showMessage show];
      [self initTrendTimer];

      return YES;

    } else {
      // Notify user that In-App Purchase is Disabled.
      NSLog(@"EBPurchase requestProduct: IAP Disabled");
      return NO;
    }

  } else {
    NSLog(@"EBPurchase requestProduct: productId = NIL");
    return NO;
  }
}
- (void)connectAppStoreFailse {
  [self stopLoading];

  [showMessage dismissWithClickedButtonIndex:0 animated:YES];

  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                 message:@"无法连接到商店，请稍后再试！"
                                delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil];
  [alertView show];
}

- (bool)purchaseProduct:(SKProduct *)requestedProduct {
  if (requestedProduct != nil) {

    NSLog(@"EBPurchase purchaseProduct: %@", requestedProduct.productIdentifier);

    if ([SKPaymentQueue canMakePayments]) {
      // Yes, In-App Purchase is enabled on this device.
      // Proceed to purchase In-App Purchase item.

      // Assign a Product ID to a new payment request.
      SKPayment *paymentRequest = [SKPayment paymentWithProduct:self.validProduct];

      // Assign an observer to monitor the transaction status.
      [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

      // Request a purchase of the product.
      [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];

      return YES;

    } else {
      // Notify user that In-App Purchase is Disabled.
      NSLog(@"EBPurchase purchaseProduct: IAP Disabled");
      return NO;
    }

  } else {
    NSLog(@"EBPurchase purchaseProduct: SKProduct = NIL");
    return NO;
  }
}

- (bool)restorePurchase {

  if ([SKPaymentQueue canMakePayments]) {
    // Yes, In-App Purchase is enabled on this device.
    // Proceed to restore purchases.

    // Assign an observer to monitor the transaction status.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    // Request to restore previous purchases.
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

    return YES;
  } else {
    // Notify user that In-App Purchase is Disabled.
    return NO;
  }
}
- (BOOL)completLastPurchaseInQueue {
  NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
  if (transactions.count > 0) {
    //检测是否有未完成的交易
    for (SKPaymentTransaction *transaction in transactions) {
      if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
        [delegate successfulPurchase:self
                          identifier:transaction.payment.productIdentifier
                             receipt:transaction.transactionReceipt];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      } else {
        return NO;
      }
    }
  }
  return YES;
}

#pragma mark
#pragma mark 定时器相关函数
//创建定时器
- (void)initTrendTimer {
  iKLTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                              target:self
                                            selector:@selector(KLineHandleTimer:)
                                            userInfo:nil
                                             repeats:NO];
}

//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (iKLTimer == theTimer) {
    [self connectAppStoreFailse];
  }
}
//定时器停止
- (void)stopMyTimer {
  if (iKLTimer != nil) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
      iKLTimer = nil;
      // NSLog(@"[iFreshTimer invalidate];");
    }
  }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate Methods

// Store Kit returns a response from an SKProductsRequest.
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {

  // Parse the received product info.
  [showMessage dismissWithClickedButtonIndex:0 animated:YES];
  [self stopMyTimer];

  NSInteger test_count = [response.products count];
  if (test_count <= 0) {
    self.validProduct = nil;
    [self stopLoading];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"数据请求失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
  } else {
    [NetLoadingWaitView startAnimating];
    self.validProduct = response.products[0];
    [self purchaseProduct:self.validProduct];
  }
  for (SKProduct *obj in response.products) {
    NSLog(@"产品id:%@ \n 产品名称：%@ \n 产品价格：%@ \n " @"产品描述：%@ " @"\n ",
          obj.productIdentifier, obj.localizedTitle, [obj.price stringValue],
          obj.localizedDescription);
  }
  if (delegate) {
    //[delegate productsRequest:request didReceiveResponse:response];
  }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

- (void)stopLoading {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
}

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {

    case SKPaymentTransactionStatePurchasing:
      // Item is still in the process of being purchased
      [NetLoadingWaitView startAnimating];
      break;

    case SKPaymentTransactionStatePurchased:
      // Item was successfully purchased!

      // Return transaction data. App should provide user with purchased
      // product.

      [delegate successfulPurchase:self
                        identifier:transaction.payment.productIdentifier
                           receipt:transaction.transactionReceipt];

      // After customer has successfully received purchased content,
      // remove the finished transaction from the payment queue.
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

      [self stopLoading];
      break;

    case SKPaymentTransactionStateRestored:
      // Verified that user has already paid for this item.
      // Ideal for restoring item across all devices of this customer.

      // Return transaction data. App should provide user with purchased
      // product.

      [delegate successfulPurchase:self
                        identifier:transaction.payment.productIdentifier
                           receipt:transaction.transactionReceipt];

      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      [self stopLoading];
      // After customer has restored purchased content on this device,
      // remove the finished transaction from the payment queue.

      break;

    case SKPaymentTransactionStateFailed:
      // Purchase was either cancelled by user or an error occurred.
      NSLog(@"Errcode:%ld \n message:%@", (long)transaction.error.code,
            transaction.error.localizedDescription);
      if (transaction.error.code != SKErrorPaymentCancelled) {
        // A transaction error occurred, so notify user.
        NSLog(@"Errcode:%ld \n message:%@", (long)transaction.error.code,
              transaction.error.localizedDescription);

        [delegate failedPurchase:self
                           error:transaction.error.code
                         message:transaction.error.localizedDescription];
      }
      // Finished transactions should be removed from the payment queue.
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
      [self stopLoading];
      break;
    }
  }
}

// Called when one or more transactions have been removed from the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
  [self stopLoading];
  NSLog(@"EBPurchase removedTransactions");

  // Release the transaction observer since transaction is finished/removed.
  [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// Called when SKPaymentQueue has finished sending restored transactions.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

  NSLog(@"EBPurchase paymentQueueRestoreCompletedTransactionsFinished");

  if ([queue.transactions count] == 0) {
    // Queue does not include any transactions, so either user has not yet made
    // a purchase
    // or the user's prior purchase is unavailable, so notify app (and user)
    // accordingly.

    NSLog(@"EBPurchase restore queue.transactions count == 0");

    // Release the transaction observer since no prior transactions were found.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

    [delegate incompleteRestore:self];

  } else {
    // Queue does contain one or more transactions, so return transaction data.
    // App should provide user with purchased product.

    NSLog(@"EBPurchase restore queue.transactions available");

    for (SKPaymentTransaction *transaction in queue.transactions) {

      NSLog(@"EBPurchase restore queue.transactions - transaction data found");

      [delegate successfulPurchase:self
                        identifier:transaction.payment.productIdentifier
                           receipt:transaction.transactionReceipt];
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
  }
}

// Called if an error occurred while restoring transactions.
- (void)paymentQueue:(SKPaymentQueue *)queue
    restoreCompletedTransactionsFailedWithError:(NSError *)error {
  // Restore was cancelled or an error occurred, so notify user.

  NSLog(@"EBPurchase restoreCompletedTransactionsFailedWithError");

  [delegate failedRestore:self error:error.code message:error.localizedDescription];
}

#pragma mark
#pragma mark UIAlertViewDelegate

// before animation and showing view
- (void)willPresentAlertView:(UIAlertView *)alertView {
  if (showMessage == alertView) {
    activeView.center =
        CGPointMake(showMessage.bounds.size.width / 2.0f, showMessage.bounds.size.height - 40.0f);
    [activeView startAnimating];
    [showMessage addSubview:activeView];
  }
}
// after animation
- (void)didPresentAlertView:(UIAlertView *)alertView {
}

#pragma mark - Internal Methods & Events

@end
