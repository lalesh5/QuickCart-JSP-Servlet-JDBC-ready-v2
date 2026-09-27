<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickCart - Account Portal</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-slate-900 min-h-screen flex items-center justify-center p-4 sm:p-6">

    <div class="w-full max-w-2xl bg-white rounded-3xl shadow-2xl overflow-hidden border border-slate-100">
        
        <!-- Header Banner Section -->
        <div class="bg-gradient-to-br from-purple-900 via-purple-800 to-indigo-900 text-white p-6 sm:p-8 relative">
            <div class="flex items-center justify-between mb-6">
                <!-- Logo -->
                <div class="flex items-center space-x-2">
                    <div class="bg-lime-400 text-purple-950 p-2.5 rounded-2xl flex items-center justify-center shadow-lg shadow-lime-400/20">
                        <i data-lucide="zap" class="w-7 h-7 fill-current"></i>
                    </div>
                    <span class="text-3xl font-black tracking-tight text-white">QUICK<span class="text-lime-400">CART.</span></span>
                </div>
                <!-- Badge -->
                <div class="bg-white/10 backdrop-blur-md px-3.5 py-1.5 rounded-full border border-white/15 text-lime-300 text-xs font-bold flex items-center space-x-1.5">
                    <i data-lucide="zap" class="w-3.5 h-3.5 fill-current"></i>
                    <span>15-Min Delivery</span>
                </div>
            </div>

            <h1 id="banner-title" class="text-2xl sm:text-3xl font-black tracking-tight mb-2">Create Your QuickCart Account</h1>
            <p id="banner-subtitle" class="text-purple-200 text-xs sm:text-sm max-w-xl leading-relaxed mb-6">
                Register now to unlock hyperlocal 15-minute delivery, exclusive deals & live order tracking.
            </p>

            <!-- Pill Badges -->
            <div class="flex flex-wrap gap-2 text-[11px] font-semibold text-purple-100">
                <span class="bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full flex items-center space-x-1.5 border border-white/10">
                    <i data-lucide="sparkles" class="w-3.5 h-3.5 text-lime-400"></i>
                    <span>10,000+ Products</span>
                </span>
                <span class="bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full flex items-center space-x-1.5 border border-white/10">
                    <i data-lucide="check-circle-2" class="w-3.5 h-3.5 text-lime-400"></i>
                    <span>Free Delivery above ₹499</span>
                </span>
                <span class="bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full flex items-center space-x-1.5 border border-white/10">
                    <i data-lucide="shield-check" class="w-3.5 h-3.5 text-lime-400"></i>
                    <span>Safe & Encrypted</span>
                </span>
            </div>
        </div>

        <!-- Navigation Tabs -->
        <div class="bg-slate-100/80 p-2 grid grid-cols-3 gap-2 border-b border-slate-200 text-xs sm:text-sm font-bold">
            <button id="tab-register" onclick="switchTab('register')" class="tab-btn bg-white text-purple-700 shadow-sm py-3 rounded-2xl flex items-center justify-center space-x-2 transition-all">
                <i data-lucide="user-plus" class="w-4 h-4"></i>
                <span>New User (Register)</span>
            </button>
            <button id="tab-login" onclick="switchTab('login')" class="tab-btn text-slate-600 hover:text-slate-900 py-3 rounded-2xl flex items-center justify-center space-x-2 transition-all">
                <i data-lucide="lock" class="w-4 h-4"></i>
                <span>Customer Login</span>
            </button>
            <button id="tab-admin" onclick="switchTab('admin')" class="tab-btn text-slate-600 hover:text-slate-900 py-3 rounded-2xl flex items-center justify-center space-x-2 transition-all">
                <i data-lucide="shield" class="w-4 h-4"></i>
                <span>Store Admin</span>
            </button>
        </div>

        <!-- Form Body -->
        <div class="p-6 sm:p-8">

            <!-- Error / Success Alert Display -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="mb-6 p-4 rounded-2xl bg-red-50 border border-red-200 text-red-600 text-sm font-medium flex items-center space-x-2">
                    <i data-lucide="alert-circle" class="w-5 h-5 flex-shrink-0"></i>
                    <span><%= error %></span>
                </div>
            <% } %>

            <!-- 1. REGISTRATION FORM (Submits to register.jsp) -->
            <form id="form-register" action="register.jsp" method="POST" class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Full Name <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <i data-lucide="user" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                        <input type="text" name="name" required placeholder="e.g. Rahul Sharma"
                               class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Email Address <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <i data-lucide="mail" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                            <input type="email" name="email" required placeholder="rahul@example.com"
                                   class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Mobile Number <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <i data-lucide="phone" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                            <input type="tel" name="phone" required placeholder="9876543210"
                                   class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Password <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <i data-lucide="lock" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                            <input type="password" id="reg-pass" name="password" required placeholder="Min 6 characters"
                                   class="w-full pl-11 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                            <button type="button" onclick="togglePass('reg-pass')" class="absolute right-3.5 top-3.5 text-slate-400 hover:text-slate-600">
                                <i data-lucide="eye" class="w-5 h-5"></i>
                            </button>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Confirm Password <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <i data-lucide="key" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                            <input type="password" id="reg-confirm" name="confirmPassword" required placeholder="Re-enter password"
                                   class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                        </div>
                    </div>
                </div>

                <button type="submit" class="w-full py-4 bg-gradient-to-r from-purple-600 to-indigo-600 text-white rounded-2xl font-bold text-base shadow-lg shadow-purple-500/25 hover:opacity-95 transition-all flex items-center justify-center space-x-2 mt-4">
                    <span>Register & Start Shopping</span>
                    <i data-lucide="arrow-right" class="w-5 h-5"></i>
                </button>

                <p class="text-center text-xs text-slate-500 font-medium pt-2">
                    Already have a QuickCart account? <a href="#" onclick="switchTab('login'); return false;" class="text-purple-700 font-bold hover:underline">Log In Here</a>
                </p>
            </form>

            <!-- 2. CUSTOMER LOGIN FORM -->
            <form id="form-login" action="login.jsp" method="POST" class="space-y-4 hidden">
                <input type="hidden" name="role" value="customer">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Email Address <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <i data-lucide="mail" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                        <input type="email" name="email" required placeholder="lalesh@gmail.com"
                               class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Password <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <i data-lucide="lock" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                        <input type="password" id="login-pass" name="password" required placeholder="Enter password"
                               class="w-full pl-11 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                        <button type="button" onclick="togglePass('login-pass')" class="absolute right-3.5 top-3.5 text-slate-400 hover:text-slate-600">
                            <i data-lucide="eye" class="w-5 h-5"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="w-full py-4 bg-gradient-to-r from-purple-600 to-indigo-600 text-white rounded-2xl font-bold text-base shadow-lg shadow-purple-500/25 hover:opacity-95 transition-all flex items-center justify-center space-x-2 mt-4">
                    <span>Sign In to QuickCart</span>
                    <i data-lucide="arrow-right" class="w-5 h-5"></i>
                </button>

                <p class="text-center text-xs text-slate-500 font-medium pt-2">
                    Don't have an account yet? <a href="#" onclick="switchTab('register'); return false;" class="text-purple-700 font-bold hover:underline">Register Now</a>
                </p>
            </form>

            <!-- 3. STORE ADMIN FORM -->
            <form id="form-admin" action="login.jsp" method="POST" class="space-y-4 hidden">
                <input type="hidden" name="role" value="admin">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Admin Email / Username <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <i data-lucide="shield-check" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                        <input type="text" name="email" required placeholder="admin@quickcart.com"
                               class="w-full pl-11 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-1.5">Admin Security Code <span class="text-red-500">*</span></label>
                    <div class="relative">
                        <i data-lucide="key" class="w-5 h-5 absolute left-3.5 top-3.5 text-slate-400"></i>
                        <input type="password" id="admin-pass" name="password" required placeholder="Enter security code"
                               class="w-full pl-11 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm focus:outline-none focus:border-purple-600 focus:bg-white transition-all">
                        <button type="button" onclick="togglePass('admin-pass')" class="absolute right-3.5 top-3.5 text-slate-400 hover:text-slate-600">
                            <i data-lucide="eye" class="w-5 h-5"></i>
                        </button>
                    </div>
                </div>

                <button type="submit" class="w-full py-4 bg-slate-900 text-white rounded-2xl font-bold text-base shadow-lg shadow-slate-900/20 hover:bg-slate-800 transition-all flex items-center justify-center space-x-2 mt-4">
                    <span>Access Admin Portal</span>
                    <i data-lucide="shield-alert" class="w-5 h-5"></i>
                </button>
            </form>

        </div>
    </div>

    <!-- Script Section for Tabs & Password Toggle -->
    <script>
        lucide.createIcons();

        function switchTab(type) {
            document.getElementById('form-register').classList.add('hidden');
            document.getElementById('form-login').classList.add('hidden');
            document.getElementById('form-admin').classList.add('hidden');

            const tabs = document.querySelectorAll('.tab-btn');
            tabs.forEach(t => {
                t.className = 'tab-btn text-slate-600 hover:text-slate-900 py-3 rounded-2xl flex items-center justify-center space-x-2 transition-all';
            });

            const activeTab = document.getElementById('tab-' + type);
            activeTab.className = 'tab-btn bg-white text-purple-700 shadow-sm py-3 rounded-2xl flex items-center justify-center space-x-2 transition-all';

            const title = document.getElementById('banner-title');
            const subtitle = document.getElementById('banner-subtitle');

            if (type === 'register') {
                document.getElementById('form-register').classList.remove('hidden');
                title.innerText = "Create Your QuickCart Account";
                subtitle.innerText = "Register now to unlock hyperlocal 15-minute delivery, exclusive deals & live order tracking.";
            } else if (type === 'login') {
                document.getElementById('form-login').classList.remove('hidden');
                title.innerText = "Welcome Back to QuickCart";
                subtitle.innerText = "Sign in to access your saved addresses, active orders, and quick re-ordering.";
            } else if (type === 'admin') {
                document.getElementById('form-admin').classList.remove('hidden');
                title.innerText = "Store Management Console";
                subtitle.innerText = "Authorized store admin portal for inventory, order fulfillment, and system logs.";
            }
        }

        function togglePass(inputId) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
            } else {
                input.type = 'password';
            }
        }
    </script>
</body>
</html>