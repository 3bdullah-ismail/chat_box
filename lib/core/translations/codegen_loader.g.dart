

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ar = {
  "hello": "مرحباً",
  "auth": {
    "resetPassword": {
      "title": "إعادة تعيين كلمة المرور",
      "description": "أدخل عنوان البريد الإلكتروني المرتبط بحسابك وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.",
      "emailAddressLabel": "البريد الإلكتروني",
      "emailHint": "name@company.com",
      "sendingBtn": "جاري الإرسال...",
      "sendResetLinkBtn": "إرسال رابط إعادة التعيين",
      "rememberedPassword": "هل تذكرت كلمة المرور؟ ",
      "signInText": "تسجيل الدخول"
    },
    "signIn": {
      "title": "تسجيل الدخول",
      "welcomeBack": "مرحباً بعودتك. أدخل بياناتك للمتابعة.",
      "emailAddressLabel": "البريد الإلكتروني",
      "emailHint": "name@company.com",
      "passwordLabel": "كلمة المرور",
      "forgotPassword": "هل نسيت كلمة المرور؟",
      "passwordHint": "أدخل كلمة المرور",
      "signingInBtn": "جاري تسجيل الدخول...",
      "signInBtn": "تسجيل الدخول",
      "orContinueWith": "أو المتابعة باستخدام",
      "dontHaveAccount": "ليس لديك حساب؟",
      "signUpText": "إنشاء حساب",
      "appleSignInComingSoon": "تسجيل الدخول بواسطة Apple قريباً"
    },
    "signUp": {
      "title": "أنشئ حسابك",
      "description": "انضم إلى المنصة المصممة للتطوير الدقيق.",
      "nameLabel": "اسمك",
      "nameHint": "جون دو",
      "usernameLabel": "اسم المستخدم",
      "usernameHint": "johndoe123",
      "emailLabel": "بريدك الإلكتروني",
      "emailHint": "name@company.com",
      "passwordLabel": "كلمة المرور",
      "passwordHint": "••••••••",
      "confirmPasswordLabel": "تأكيد كلمة المرور",
      "signingUpBtn": "جاري إنشاء الحساب...",
      "signUpBtn": "إنشاء حساب",
      "socialIdentity": "الهوية الاجتماعية",
      "alreadyHaveAccount": "هل لديك حساب بالفعل؟",
      "signInText": "تسجيل الدخول",
      "termsAndPrivacy": "بالنقر على \"إنشاء حساب\"، فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بنا. يتم التعامل مع معالجة البيانات بدقة تقنية.",
      "verificationEmailSent": "تم إرسال بريد التحقق"
    },
    "social": {
      "google": "Google",
      "apple": "Apple"
    }
  },
  "chat": {
    "page": {
      "deleteForEveryone": "حذف لدى الجميع",
      "deleteForMe": "حذف لدي",
      "copy": "نسخ",
      "cancel": "إلغاء",
      "typing": "يكتب...",
      "online": "متصل الآن",
      "offline": "غير متصل",
      "lastSeen": "آخر ظهور {}",
      "noMessages": "لا توجد رسائل بعد.\nقل مرحباً! 👋",
      "messageDeleted": "🚫 تم حذف هذه الرسالة",
      "messageHint": "رسالة..."
    },
    "chatsPage": {
      "searchHint": "ابحث عن أشخاص"
    },
    "chatCard": {
      "chatUser": "مستخدم",
      "tapToStart": "اضغط لبدء الدردشة..."
    },
    "emptyChats": {
      "title": "لا توجد محادثات\nبعد",
      "description": "ابدأ محادثة جديدة للتواصل مع أصدقائك وزملائك. ستظهر رسائلك الخاصة والجماعية هنا.",
      "startChattingBtn": "ابدأ الدردشة",
      "discoverPeopleBtn": "اكتشف أشخاصاً جدد"
    }
  },
  "friends": {
    "addFriends": {
      "title": "إضافة أصدقاء",
      "searchHint": "ابحث باسم المستخدم، البريد الإلكتروني، أو الهاتف",
      "successMsg": "تم إرسال طلب الصداقة بنجاح!",
      "emptyStateTitle": "لم يتم العثور على مستخدمين",
      "emptyStateDesc": "لم نتمكن من العثور على أي شخص يطابق بحثك. جرب البحث باسم المستخدم أو البريد الإلكتروني."
    },
    "friendRequests": {
      "title": "طلبات الصداقة",
      "tabReceived": "المستلمة",
      "tabSent": "المرسلة",
      "successMsg": "تم قبول طلب الصداقة!"
    },
    "cards": {
      "mutualFriend": "صديق مشترك",
      "addFriendBtn": "إضافة صديق",
      "acceptBtn": "قبول",
      "declineBtn": "رفض",
      "cancelRequestBtn": "إلغاء الطلب"
    },
    "emptyState": {
      "title": "الأصدقاء",
      "emptyTitle": "لا يوجد أصدقاء بعد",
      "emptyDesc": "لم تقم بإضافة أي أصدقاء بعد. ابدأ\nالتواصل مع الأشخاص للدردشة والمكالمات\nومشاركة اللحظات معاً.",
      "addFriendsBtn": "إضافة أصدقاء",
      "viewRequestsBtn": "عرض الطلبات المرسلة/المستلمة"
    },
    "mainContent": {
      "title": "الأصدقاء",
      "searchHint": "ابحث باسم المستخدم، البريد الإلكتروني، أو الهاتف",
      "requestsSectionTitle": "طلبات الصداقة",
      "viewAllBtn": "عرض الكل",
      "friendsSectionTitle": "أصدقائي"
    },
    "receivedRequests": {
      "emptyStateTitle": "لا توجد طلبات مستلمة",
      "emptyStateDesc": "عندما يرسل لك شخص طلب صداقة، سيظهر هنا."
    },
    "sentRequests": {
      "emptyStateTitle": "لا توجد طلبات مرسلة",
      "emptyStateDesc": "لم تقم بإرسال أي طلبات صداقة بعد. اذهب وابحث عن بعض الأصدقاء!"
    }
  },
  "layout": {
    "chatsTab": "المحادثات",
    "friendsTab": "الأصدقاء",
    "profileTab": "الملف الشخصي"
  },
  "onboarding": {
    "screenLabel": "شاشة الترحيب",
    "appName": "Silora",
    "appNameSemantics": "اسم التطبيق: Silora",
    "subtitle": "حيث كل تواصل يهم",
    "description": "سيلورا تقرب الأشخاص من بعضهم من خلال محادثات بسيطة وآمنة وذات مغزى. ابق على اتصال مع الأصدقاء والعائلة والأشخاص الأهم بالنسبة لك.",
    "startConnectingBtn": "ابدأ التواصل",
    "previewSemantics": "معاينة تجربة المراسلة في Silora",
    "mockChatBubbleText": "مرحباً بك في Silora.\nابق قريباً من الأشخاص الذين يهمونك."
  },
  "profile": {
    "editProfile": {
      "title": "تعديل الملف الشخصي",
      "fullNameLabel": "الاسم الكامل",
      "nameHint": "أدخل اسمك",
      "nameEmptyErr": "لا يمكن ترك الاسم فارغاً",
      "bioLabel": "النبذة التعريفية",
      "bioHint": "تحدث عن نفسك",
      "addressLabel": "العنوان",
      "addressHint": "مثال: القاهرة، مصر",
      "saveBtn": "حفظ التغييرات"
    },
    "profilePage": {
      "retryBtn": "إعادة المحاولة",
      "signOutBtn": "تسجيل الخروج",
      "signOutConfirmationMsg": "هل أنت متأكد أنك تريد تسجيل الخروج؟"
    },
    "notifications": {
      "title": "الإشعارات"
    },
    "personalInfo": {
      "title": "المعلومات الشخصية",
      "addressNotProvided": "غير متوفر",
      "joinedPrefix": "انضم في ",
      "joinedRecently": "انضم حديثاً"
    }
  },
  "core": {
    "dialog": {
      "error": "خطأ",
      "success": "نجاح",
      "warning": "تحذير"
    },
    "time": {
      "justNow": "الآن",
      "minAgo": "د مضت"
    },
    "validation": {
      "emailEmpty": "لا يمكن ترك البريد الإلكتروني فارغاً.",
      "emailInvalid": "يرجى إدخال عنوان بريد إلكتروني صالح.",
      "passwordEmpty": "يرجى إدخال كلمة المرور",
      "passwordInvalid": "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل\n وتحتوي على أحرف كبيرة وصغيرة،\n رقم ورمز خاص",
      "confirmPasswordEmpty": "يرجى تأكيد كلمة المرور",
      "passwordsNotMatch": "كلمتا المرور غير متطابقتين",
      "usernameEmpty": "لا يمكن ترك اسم المستخدم فارغاً.",
      "usernameInvalid": "يجب أن يتكون اسم المستخدم من 3 أحرف على الأقل."
    }
  }
};
static const Map<String,dynamic> _en = {
  "hello": "Hello",
  "auth": {
    "resetPassword": {
      "title": "Reset Password",
      "description": "Enter the email address associated with your account and we'll send you a link to reset your password.",
      "emailAddressLabel": "Email Address",
      "emailHint": "name@company.com",
      "sendingBtn": "Sending...",
      "sendResetLinkBtn": "Send Reset Link",
      "rememberedPassword": "Remembered your password? ",
      "signInText": "Sign in"
    },
    "signIn": {
      "title": "Sign In",
      "welcomeBack": "Welcome back. Enter your details to\ncontinue.",
      "emailAddressLabel": "EMAIL ADDRESS",
      "emailHint": "name@company.com",
      "passwordLabel": "PASSWORD",
      "forgotPassword": "Forgot Password?",
      "passwordHint": "Enter your password",
      "signingInBtn": "Signing In...",
      "signInBtn": "Sign In",
      "orContinueWith": "OR CONTINUE WITH",
      "dontHaveAccount": "Don't have an account?",
      "signUpText": "Sign Up",
      "appleSignInComingSoon": "Apple Sign-In coming soon"
    },
    "signUp": {
      "title": "Create your account",
      "description": "Join the platform built for precision\ndevelopment.",
      "nameLabel": "Your Name",
      "nameHint": "John Doe",
      "usernameLabel": "Username",
      "usernameHint": "johndoe123",
      "emailLabel": "Your Email",
      "emailHint": "name@company.com",
      "passwordLabel": "Password",
      "passwordHint": "••••••••",
      "confirmPasswordLabel": "Confirm Password",
      "signingUpBtn": "Signing Up...",
      "signUpBtn": "Sign Up",
      "socialIdentity": "SOCIAL IDENTITY",
      "alreadyHaveAccount": "Already have an account?",
      "signInText": "Sign In",
      "termsAndPrivacy": "By clicking \"Create Account\", you agree to our Terms of Service and Privacy Policy. Data processing is handled with technical precision.",
      "verificationEmailSent": "Verification Email Sent"
    },
    "social": {
      "google": "Google",
      "apple": "Apple"
    }
  },
  "chat": {
    "page": {
      "deleteForEveryone": "Delete for everyone",
      "deleteForMe": "Delete for me",
      "copy": "Copy",
      "cancel": "Cancel",
      "typing": "Typing...",
      "online": "Online",
      "offline": "Offline",
      "lastSeen": "Last seen {}",
      "noMessages": "No messages yet.\nSay Hello! 👋",
      "messageDeleted": "🚫 This message was deleted",
      "messageHint": "Message..."
    },
    "chatsPage": {
      "searchHint": "Search for people"
    },
    "chatCard": {
      "chatUser": "Chat User",
      "tapToStart": "Tap to start chatting..."
    },
    "emptyChats": {
      "title": "No Conversations\nYet",
      "description": "Start a new chat to connect with your friends and colleagues. Your private and group messages will appear here.",
      "startChattingBtn": "Start Chatting",
      "discoverPeopleBtn": "Discover People"
    }
  },
  "friends": {
    "addFriends": {
      "title": "Add Friends",
      "searchHint": "Search by username, email, or phone",
      "successMsg": "Friend request sent successfully!",
      "emptyStateTitle": "No Users Found",
      "emptyStateDesc": "We couldn't find anyone matching your search query. Try searching by username or email."
    },
    "friendRequests": {
      "title": "Friend Requests",
      "tabReceived": "Received",
      "tabSent": "Sent",
      "successMsg": "Friend request accepted!"
    },
    "cards": {
      "mutualFriend": "Mutual Friend",
      "addFriendBtn": "Add Friend",
      "acceptBtn": "Accept",
      "declineBtn": "Decline",
      "cancelRequestBtn": "Cancel Request"
    },
    "emptyState": {
      "title": "Friends",
      "emptyTitle": "No Friends Yet",
      "emptyDesc": "You haven't added any friends yet. Start\nconnecting with people to chat, call and\nshare moments together.",
      "addFriendsBtn": "Add Friends",
      "viewRequestsBtn": "View Sent/Received Requests"
    },
    "mainContent": {
      "title": "Friends",
      "searchHint": "Search by username, email, or phone",
      "requestsSectionTitle": "Friend Requests",
      "viewAllBtn": "View All",
      "friendsSectionTitle": "My Friends"
    },
    "receivedRequests": {
      "emptyStateTitle": "No Received Requests",
      "emptyStateDesc": "When someone sends you a friend request, it will appear here."
    },
    "sentRequests": {
      "emptyStateTitle": "No Sent Requests",
      "emptyStateDesc": "You haven't sent any friend requests yet. Go find some friends!"
    }
  },
  "layout": {
    "chatsTab": "Chats",
    "friendsTab": "Friends",
    "profileTab": "Profile"
  },
  "onboarding": {
    "screenLabel": "Onboarding Screen",
    "appName": "Silora",
    "appNameSemantics": "App Name: Silora",
    "subtitle": "Where Every Connection Matters",
    "description": "Silora brings people closer through simple, secure, and meaningful conversations. Stay connected with friends, family, and the people who matter most.",
    "startConnectingBtn": "Start Connecting",
    "previewSemantics": "Silora messaging experience preview",
    "mockChatBubbleText": "Welcome to Silora.\nStay close to the people who matter."
  },
  "profile": {
    "editProfile": {
      "title": "Edit Profile",
      "fullNameLabel": "Full Name",
      "nameHint": "Enter your name",
      "nameEmptyErr": "Name cannot be empty",
      "bioLabel": "Bio",
      "bioHint": "Tell us about yourself",
      "addressLabel": "Address",
      "addressHint": "E.g. Cairo, Egypt",
      "saveBtn": "Save Changes"
    },
    "profilePage": {
      "retryBtn": "Retry",
      "signOutBtn": "Sign out",
      "signOutConfirmationMsg": "Are you sure you want to sign out?"
    },
    "notifications": {
      "title": "Notifications"
    },
    "personalInfo": {
      "title": "Personal Info",
      "addressNotProvided": "Not provided",
      "joinedPrefix": "Joined ",
      "joinedRecently": "Joined recently"
    }
  },
  "core": {
    "dialog": {
      "error": "Error",
      "success": "Success",
      "warning": "Warning"
    },
    "time": {
      "justNow": "Just now",
      "minAgo": "min ago"
    },
    "validation": {
      "emailEmpty": "Email cannot be empty.",
      "emailInvalid": "Please enter a valid email address.",
      "passwordEmpty": "Please enter password",
      "passwordInvalid": "Password must be at least 8 chars\n and contain upper, lower,\n number & special char",
      "confirmPasswordEmpty": "Please confirm your password",
      "passwordsNotMatch": "Passwords do not match",
      "usernameEmpty": "Username cannot be empty.",
      "usernameInvalid": "Username must be at least 3 characters."
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}