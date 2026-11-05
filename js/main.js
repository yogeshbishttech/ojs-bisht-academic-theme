/**
 * Bisht Academic Theme - Main JavaScript
 * 
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 */

(function($) {
    'use strict';
    
    // Wait for DOM to be ready
    $(document).ready(function() {
        
        // Initialize all components
        initMobileMenu();
        initSearchToggle();
        initBackToTop();
        initSmoothScroll();
        initStickyNavigation();
        initAnimations();
    });
    
    /**
     * Mobile Menu Toggle
     */
    function initMobileMenu() {
        $('.mobile-menu-toggle').on('click', function() {
            $('.nav-menu').toggleClass('active');
            $(this).find('i').toggleClass('fa-bars fa-times');
        });
        
        // Close mobile menu when clicking outside
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.main-navigation').length) {
                $('.nav-menu').removeClass('active');
                $('.mobile-menu-toggle i').removeClass('fa-times').addClass('fa-bars');
            }
        });
        
        // Close mobile menu on window resize
        $(window).on('resize', function() {
            if ($(window).width() > 768) {
                $('.nav-menu').removeClass('active');
                $('.mobile-menu-toggle i').removeClass('fa-times').addClass('fa-bars');
            }
        });
    }
    
    /**
     * Search Toggle
     */
    function initSearchToggle() {
        $('.search-toggle').on('click', function(e) {
            e.preventDefault();
            $('.search-container').slideToggle(300);
            setTimeout(function() {
                $('.search-input').focus();
            }, 350);
        });
        
        $('.search-close').on('click', function(e) {
            e.preventDefault();
            $('.search-container').slideUp(300);
        });
        
        // Close search on ESC key
        $(document).on('keydown', function(e) {
            if (e.key === 'Escape' || e.keyCode === 27) {
                $('.search-container').slideUp(300);
            }
        });
    }
    
    /**
     * Back to Top Button
     */
    function initBackToTop() {
        var $backToTop = $('#back-to-top');
        
        // Show/hide button based on scroll position
        $(window).on('scroll', function() {
            if ($(this).scrollTop() > 300) {
                $backToTop.addClass('show');
            } else {
                $backToTop.removeClass('show');
            }
        });
        
        // Scroll to top on click
        $backToTop.on('click', function(e) {
            e.preventDefault();
            $('html, body').animate({
                scrollTop: 0
            }, 800, 'swing');
        });
    }
    
    /**
     * Smooth Scroll for Anchor Links
     */
    function initSmoothScroll() {
        $('a[href^="#"]').not('[href="#"]').on('click', function(e) {
            // Look the target up by id instead of passing the href to jQuery as a selector
            var element = document.getElementById(this.getAttribute('href').slice(1));
            var target = $(element);
            
            if (element) {
                e.preventDefault();
                
                var offset = 100; // Account for sticky header
                var scrollTop = target.offset().top - offset;
                
                $('html, body').stop().animate({
                    scrollTop: scrollTop
                }, 1000, 'swing');
            }
        });
    }
    
    /**
     * Sticky Navigation
     */
    function initStickyNavigation() {
        var $nav = $('.main-navigation');
        var $topNav = $('.top-navbar');
        var navOffset = $nav.length ? $nav.offset().top : 0;
        
        $(window).on('scroll', function() {
            var scrollTop = $(this).scrollTop();
            
            if (scrollTop > navOffset) {
                $nav.addClass('is-sticky');
                $topNav.addClass('nav-scrolled');
            } else {
                $nav.removeClass('is-sticky');
                $topNav.removeClass('nav-scrolled');
            }
        });
    }
    
    /**
     * Scroll Animations
     */
    function initAnimations() {
        // Fade in elements on scroll
        var $animatedElements = $('.info-card, .widget, .article-summary');
        
        function checkAnimation() {
            var windowHeight = $(window).height();
            var scrollTop = $(window).scrollTop();
            
            $animatedElements.each(function() {
                var $element = $(this);
                var elementTop = $element.offset().top;
                
                if (elementTop < scrollTop + windowHeight - 100) {
                    $element.addClass('animate-in');
                }
            });
        }
        
        // Initial check
        checkAnimation();
        
        // Check on scroll
        $(window).on('scroll', throttle(checkAnimation, 100));
    }
    
    /**
     * Utility Functions
     */
    
    // Throttle function for performance
    function throttle(func, delay) {
        var lastCall = 0;
        return function() {
            var now = new Date().getTime();
            if (now - lastCall < delay) {
                return;
            }
            lastCall = now;
            return func.apply(this, arguments);
        };
    }
    
    // Show notification
    function showNotification(message, type) {
        type = type || 'info';
        
        // Insert the message as a text node so it can never be parsed as HTML
        var $notification = $('<div>')
            .addClass('theme-notification ' + type)
            .append($('<i>').addClass('fas fa-' + getNotificationIcon(type)))
            .append(document.createTextNode(' ' + message))
            .hide();
        
        $('body').append($notification);
        
        $notification.fadeIn(300).delay(3000).fadeOut(300, function() {
            $(this).remove();
        });
    }
    
    // Get notification icon based on type
    function getNotificationIcon(type) {
        var icons = {
            'success': 'check-circle',
            'error': 'exclamation-circle',
            'warning': 'exclamation-triangle',
            'info': 'info-circle'
        };
        return icons[type] || icons.info;
    }
    
    /**
     * Article Metrics Counter Animation
     */
    function animateCounters() {
        $('.metric-number').each(function() {
            var $this = $(this);
            var text = $this.text();
            var number = parseInt(text.replace(/\D/g, ''));
            
            if (isNaN(number)) return;
            
            var suffix = text.replace(/[0-9]/g, '');
            
            $({ Counter: 0 }).animate({ Counter: number }, {
                duration: 2000,
                easing: 'swing',
                step: function() {
                    $this.text(Math.ceil(this.Counter) + suffix);
                }
            });
        });
    }
    
    // Trigger counter animation when metrics section is visible
    var metricsAnimated = false;
    $(window).on('scroll', function() {
        if (metricsAnimated) return;
        
        var $metrics = $('.key-metrics');
        if ($metrics.length && isElementInViewport($metrics[0])) {
            animateCounters();
            metricsAnimated = true;
        }
    });
    
    // Check if element is in viewport
    function isElementInViewport(el) {
        var rect = el.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
    
    /**
     * Cookie Consent (Optional)
     */
    function initCookieConsent() {
        // Check if user has already accepted cookies
        if (localStorage.getItem('cookieConsent') === 'accepted') {
            return;
        }
        
        var $cookieBanner = $('<div class="cookie-consent">')
            .html(
                '<div class="container">' +
                '<p><i class="fas fa-cookie-bite"></i> This website uses cookies to ensure you get the best experience. ' +
                '<a href="#">Learn more</a></p>' +
                '<button class="btn btn-sm btn-primary accept-cookies">Accept</button>' +
                '</div>'
            );
        
        $('body').append($cookieBanner);
        
        setTimeout(function() {
            $cookieBanner.addClass('show');
        }, 1000);
        
        $('.accept-cookies').on('click', function() {
            localStorage.setItem('cookieConsent', 'accepted');
            $cookieBanner.removeClass('show');
            setTimeout(function() {
                $cookieBanner.remove();
            }, 300);
        });
    }
    
    // Uncomment to enable cookie consent
    // initCookieConsent();
    
    /**
     * Print Article Function
     */
    window.printArticle = function() {
        window.print();
    };
    
    /**
     * Share Article Function
     */
    window.shareArticle = function(platform, url, title) {
        var shareUrls = {
            'facebook': 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(url),
            'twitter': 'https://twitter.com/intent/tweet?url=' + encodeURIComponent(url) + '&text=' + encodeURIComponent(title),
            'linkedin': 'https://www.linkedin.com/sharing/share-offsite/?url=' + encodeURIComponent(url),
            'whatsapp': 'https://api.whatsapp.com/send?text=' + encodeURIComponent(title + ' ' + url),
            'email': 'mailto:?subject=' + encodeURIComponent(title) + '&body=' + encodeURIComponent(url)
        };
        
        if (shareUrls[platform]) {
            if (platform === 'email') {
                window.location.href = shareUrls[platform];
            } else {
                window.open(shareUrls[platform], '_blank', 'width=600,height=400');
            }
        }
    };
    
    /**
     * Copy Citation to Clipboard
     */
    window.copyCitation = function(citation) {
        var $temp = $('<textarea>');
        $('body').append($temp);
        $temp.val(citation).select();
        document.execCommand('copy');
        $temp.remove();
        
        showNotification('Citation copied to clipboard!', 'success');
    };
    
})(jQuery);
