sealed class IEndpoints {
  String get supabaseUrl;

  String get supabaseAnonKey;

  String get baseUrl;

  String get id;
}

class PreReleaseEndpoints implements IEndpoints {
  const PreReleaseEndpoints();

  @override
  String get supabaseUrl => 'https://kvzimnihcfzkhocqussn.supabase.co';

  @override
  String get supabaseAnonKey =>
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt2emltbmloY2Z6a2hvY3F1c3NuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyNjU0NzksImV4cCI6MjA3MDg0MTQ3OX0.67dRx0gPudbO8QRb9BZiLqOfVNZMbA5l8pxbHbKFQR8';

  @override
  String get id => 'pre-release';

  @override
  String get baseUrl => "http://10.0.2.2:5041";
}

class ProductionEndpoints implements IEndpoints {
  const ProductionEndpoints();

  @override
  String get supabaseUrl => 'https://kvzimnihcfzkhocqussn.supabase.co';

  @override
  String get supabaseAnonKey =>
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt2emltbmloY2Z6a2hvY3F1c3NuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyNjU0NzksImV4cCI6MjA3MDg0MTQ3OX0.67dRx0gPudbO8QRb9BZiLqOfVNZMbA5l8pxbHbKFQR8';

  @override
  String get id => 'production';

  @override
  String get baseUrl => "https://backend.ovdix.com";
}
