// lib/translations/app_translations.dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          // Navigation
          'dashboard': 'Dashboard',
          'admin_users': 'Admin Users',
          'customers': 'Customers',
          'services': 'Services',
          'sub_services': 'Sub Services',
          'sub_services_by_car': 'Sub Services By Car',
          'orders': 'Orders',
          'payments': 'Payments',
          'change_theme': 'Change Theme',
          'change_language': 'Change Language',
          'settings': 'Settings',
          'logout': 'Logout',

          // Dashboard
          'welcome_admin': 'Welcome to Admin Panel',
          'total_users': 'Total Users',
          'total_orders': 'Total Orders',
          'total_revenue': 'Total Revenue',
          'pending_orders': 'Pending Orders',
          'completed_orders': 'Completed Orders',
          'active_services': 'Active Services',
          'recent_orders': 'Recent Orders',
          'statistics': 'Statistics',

          // Common
          'search': 'Search',
          'add_new': 'Add New',
          'edit': 'Edit',
          'delete': 'Delete',
          'save': 'Save',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
          'loading': 'Loading...',
          'no_data': 'No data available',
          'success': 'Success',
          'error': 'Error',
          'warning': 'Warning',
          'info': 'Info',

          // User Management
          'user_name': 'User Name',
          'phone_number': 'Phone Number',
          'status': 'Status',
          'created_at': 'Created At',
          'active': 'Active',
          'inactive': 'Inactive',
          'banned': 'Banned',
          'approve': 'Approve',
          'reject': 'Reject',

          // Services
          'service_name': 'Service Name',
          'service_image': 'Service Image',
          'price': 'Price',
          'add_service': 'Add Service',
          'edit_service': 'Edit Service',
          'delete_service': 'Delete Service',

          // Orders
          'order_number': 'Order Number',
          'customer': 'Customer',
          'order_date': 'Order Date',
          'order_status': 'Order Status',
          'payment_status': 'Payment Status',
          'total_amount': 'Total Amount',
          'pending': 'Pending',
          'confirmed': 'Confirmed',
          'in_progress': 'In Progress',
          'completed': 'Completed',
          'cancelled': 'Cancelled',

          // Payments
          'payment_method': 'Payment Method',
          'payment_date': 'Payment Date',
          'amount': 'Amount',
          'cash': 'Cash',
          'card': 'Card',
          'online': 'Online',

          // Vehicles
          'license_plate': 'License Plate',
          'vehicle_make': 'Vehicle Make',
          'vehicle_model': 'Vehicle Model',
          'vehicle_year': 'Vehicle Year',

          // Notifications
          'notification_sent': 'Notification sent successfully',
          'user_updated': 'User updated successfully',
          'service_added': 'Service added successfully',
          'order_updated': 'Order updated successfully',
          'payment_processed': 'Payment processed successfully',

          // Validation
          'field_required': 'This field is required',
          'invalid_email': 'Invalid email address',
          'invalid_phone': 'Invalid phone number',
          'min_length': 'Minimum length is @count characters',
          'max_length': 'Maximum length is @count characters',

          // Actions
          'view_details': 'View Details',
          'download': 'Download',
          'export': 'Export',
          'import': 'Import',
          'refresh': 'Refresh',
          'filter': 'Filter',
          'sort': 'Sort',
        },
        'ar': {
          // Navigation
          'dashboard': 'لوحة التحكم',
          'admin_users': 'المشرفين',
          'customers': 'العملاء',
          'services': 'الخدمات',
          'sub_services': 'الخدمات الفرعية',
          'sub_services_by_car': 'الخدمات حسب السيارة',
          'orders': 'الطلبات',
          'payments': 'المدفوعات',
          'change_theme': 'تغيير المظهر',
          'change_language': 'تغيير اللغة',
          'settings': 'الإعدادات',
          'logout': 'تسجيل الخروج',

          // Dashboard
          'welcome_admin': 'مرحباً بك في لوحة التحكم',
          'total_users': 'إجمالي المستخدمين',
          'total_orders': 'إجمالي الطلبات',
          'total_revenue': 'إجمالي الإيرادات',
          'pending_orders': 'الطلبات المعلقة',
          'completed_orders': 'الطلبات المكتملة',
          'active_services': 'الخدمات النشطة',
          'recent_orders': 'الطلبات الأخيرة',
          'statistics': 'الإحصائيات',

          // Common
          'search': 'بحث',
          'add_new': 'إضافة جديد',
          'edit': 'تعديل',
          'delete': 'حذف',
          'save': 'حفظ',
          'cancel': 'إلغاء',
          'confirm': 'تأكيد',
          'loading': 'جاري التحميل...',
          'no_data': 'لا توجد بيانات متاحة',
          'success': 'نجح',
          'error': 'خطأ',
          'warning': 'تحذير',
          'info': 'معلومات',

          // User Management
          'user_name': 'اسم المستخدم',
          'phone_number': 'رقم الهاتف',
          'status': 'الحالة',
          'created_at': 'تاريخ الإنشاء',
          'active': 'نشط',
          'inactive': 'غير نشط',
          'banned': 'محظور',
          'approve': 'موافقة',
          'reject': 'رفض',

          // Services
          'service_name': 'اسم الخدمة',
          'service_image': 'صورة الخدمة',
          'price': 'السعر',
          'add_service': 'إضافة خدمة',
          'edit_service': 'تعديل الخدمة',
          'delete_service': 'حذف الخدمة',

          // Orders
          'order_number': 'رقم الطلب',
          'customer': 'العميل',
          'order_date': 'تاريخ الطلب',
          'order_status': 'حالة الطلب',
          'payment_status': 'حالة الدفع',
          'total_amount': 'المبلغ الإجمالي',
          'pending': 'معلق',
          'confirmed': 'مؤكد',
          'in_progress': 'قيد التنفيذ',
          'completed': 'مكتمل',
          'cancelled': 'ملغي',

          // Payments
          'payment_method': 'طريقة الدفع',
          'payment_date': 'تاريخ الدفع',
          'amount': 'المبلغ',
          'cash': 'نقدي',
          'card': 'بطاقة',
          'online': 'إلكتروني',

          // Vehicles
          'license_plate': 'لوحة الترخيص',
          'vehicle_make': 'صانع السيارة',
          'vehicle_model': 'موديل السيارة',
          'vehicle_year': 'سنة السيارة',

          // Notifications
          'notification_sent': 'تم إرسال الإشعار بنجاح',
          'user_updated': 'تم تحديث المستخدم بنجاح',
          'service_added': 'تم إضافة الخدمة بنجاح',
          'order_updated': 'تم تحديث الطلب بنجاح',
          'payment_processed': 'تم معالجة الدفع بنجاح',

          // Validation
          'field_required': 'هذا الحقل مطلوب',
          'invalid_email': 'عنوان بريد إلكتروني غير صحيح',
          'invalid_phone': 'رقم هاتف غير صحيح',
          'min_length': 'الحد الأدنى للطول هو @count حرف',
          'max_length': 'الحد الأقصى للطول هو @count حرف',

          // Actions
          'view_details': 'عرض التفاصيل',
          'download': 'تحميل',
          'export': 'تصدير',
          'import': 'استيراد',
          'refresh': 'تحديث',
          'filter': 'تصفية',
          'sort': 'ترتيب',
        },
      };
}
