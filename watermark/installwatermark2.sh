#!/bin/bash

REMOTE_PATH="/var/www/pterodactyl/resources/views/admin/index.blade.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
BACKUP_PATH="${REMOTE_PATH}.bak_${TIMESTAMP}"

# Backup file lama jika ada
if [ -f "$REMOTE_PATH" ]; then
  mv "$REMOTE_PATH" "$BACKUP_PATH"
fi

mkdir -p "$(dirname "$REMOTE_PATH")"
chmod 755 "$(dirname "$REMOTE_PATH")"

cat > "$REMOTE_PATH" <<'EOF'
@extends('layouts.admin')

@section('title')
    Administration
@endsection

@section('content-header')
    <h1>Fhiya Frinella ©arifyProject
        <small>Developer arifyProject change the appearance</small>
    </h1>
@endsection

@section('content')
<style>
    .donation-btn {
        font-size: 18px;
        padding: 12px;
        margin-bottom: 20px;
        transition: all 0.3s ease;
    }
    
    .donation-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.8);
        z-index: 9999;
        animation: fadeIn 0.3s ease;
    }

    .modal-overlay.active {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background: white;
        width: 90%;
        max-width: 400px;
        padding: 20px;
        border-radius: 15px;
        position: relative;
        animation: slideIn 0.3s ease;
        box-shadow: 0 10px 40px rgba(0,0,0,0.3);
    }

    .modal-close {
        position: absolute;
        top: 10px;
        right: 10px;
        background: #d9534f;
        border: none;
        color: white;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        cursor: pointer;
        font-size: 18px;
        font-weight: bold;
        transition: all 0.2s ease;
    }

    .modal-close:hover {
        background: #c9302c;
        transform: rotate(90deg);
    }

    .qris-image {
        width: 100%;
        aspect-ratio: 1/1;
        border-radius: 10px;
        object-fit: cover;
        margin-top: 25px;
        border: 3px solid #f0f0f0;
    }

    .media-container {
        position: relative;
        overflow: hidden;
        border-radius: 10px;
        background: #000;
    }

    .media-container video,
    .media-container img {
        width: 100%;
        max-width: 700px;
        border-radius: 10px;
        object-fit: cover;
        display: block;
        margin: 0 auto;
    }

    .media-container video {
        cursor: pointer;
        max-height: 500px;
    }

    .video-mute-indicator {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 15px 25px;
        border-radius: 50px;
        font-size: 24px;
        pointer-events: none;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .video-mute-indicator.show {
        opacity: 1;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes slideIn {
        from { 
            transform: translateY(-50px);
            opacity: 0;
        }
        to { 
            transform: translateY(0);
            opacity: 1;
        }
    }

    @media (max-width: 768px) {
        .donation-btn {
            font-size: 16px;
            padding: 10px;
        }
        
        .modal-content {
            width: 95%;
            padding: 15px;
        }
    }
    
    .btn-group-wrapper {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 10px;
        padding: 5px;
    }
    
    .quick-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        padding: 15px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 8px;
        text-decoration: none;
        transition: all 0.3s ease;
        font-weight: 500;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .quick-btn:nth-child(1) {
        background: linear-gradient(135deg, #3c8dbc 0%, #2c6fa5 100%);
    }
    
    .quick-btn:nth-child(2) {
        background: linear-gradient(135deg, #00a65a 0%, #008d4c 100%);
    }
    
    .quick-btn:nth-child(3) {
        background: linear-gradient(135deg, #f39c12 0%, #e08e0b 100%);
    }
    
    .quick-btn:nth-child(4) {
        background: linear-gradient(135deg, #dd4b39 0%, #d33724 100%);
    }
    
    .quick-btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 16px rgba(0,0,0,0.2);
        color: white;
        text-decoration: none;
    }
    
    .quick-btn i {
        font-size: 20px;
    }
    
    .quick-btn span {
        font-size: 14px;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .btn-group-wrapper {
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
        }
        
        .quick-btn {
            padding: 12px 15px;
        }
        
        .quick-btn i {
            font-size: 18px;
        }
        
        .quick-btn span {
            font-size: 13px;
        }
    }
    
    @media (max-width: 480px) {
        .btn-group-wrapper {
            gap: 6px;
        }
        
        .quick-btn {
            padding: 10px 12px;
            flex-direction: column;
            gap: 5px;
        }
        
        .quick-btn i {
            font-size: 24px;
        }
        
        .quick-btn span {
            font-size: 12px;
        }
    }
    .timeline-compact {
        list-style: none;
        padding: 0;
        position: relative;
    }
    
    .timeline-compact:before {
        content: '';
        position: absolute;
        top: 0;
        bottom: 0;
        width: 2px;
        background: #e0e0e0;
        left: 30px;
        margin: 0;
    }
    
    .timeline-compact > li {
        margin-bottom: 15px;
        position: relative;
    }
    
    .timeline-compact > li > .fa {
        width: 30px;
        height: 30px;
        font-size: 14px;
        line-height: 30px;
        position: absolute;
        color: #fff;
        background: #999;
        border-radius: 50%;
        text-align: center;
        left: 15px;
        top: 0;
    }
    
    .timeline-item {
        background: #f9f9f9;
        border: 1px solid #e0e0e0;
        border-radius: 5px;
        margin-left: 60px;
        padding: 10px;
    }
    
    .timeline-item .time {
        color: #999;
        font-size: 11px;
    }
    
    .timeline-header {
        margin: 5px 0;
        font-size: 14px;
        font-weight: 600;
    }
    
    .timeline-body {
        font-size: 13px;
        color: #666;
    }
    
    .time-label > span {
        display: inline-block;
        background: #3c8dbc;
        color: white;
        padding: 5px 15px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
    }
    
    .status-item {
        margin-bottom: 20px;
    }
    
    .status-label {
        font-weight: 600;
        font-size: 13px;
        display: inline-block;
        width: 40%;
    }
    
    .status-value {
        float: right;
        font-weight: 700;
        color: #666;
    }
    
    .progress-sm {
        height: 10px;
        margin-top: 5px;
    }
</style>

<!-- Donation Button -->
<div class="row">
    <div class="col-xs-12">
        <button class="btn btn-success btn-block donation-btn" id="btnDonasi">
            <i class="fa fa-money"></i> Support via Donasi
        </button>
    </div>
</div>

<!-- QRIS Modal -->
<div id="qrisModal" class="modal-overlay" role="dialog" aria-labelledby="modalTitle" aria-modal="true">
    <div class="modal-content" role="document">
        <button id="closeModal" class="modal-close" aria-label="Close modal">
            ×
        </button>
        
        <h4 id="modalTitle" style="margin-top: 10px; text-align: center;">
            Scan QRIS untuk Donasi
        </h4>
        
        <img src="https://raw.githubusercontent.com/yopi-def/panel-installer/refs/heads/main/disk/qris.jpg"
             alt="QRIS Code"
             class="qris-image"
             loading="lazy">
        
        <a href="https://raw.githubusercontent.com/yopi-def/panel-installer/refs/heads/main/disk/qris.jpg"
           download="qris-donation.jpg"
           class="btn btn-primary btn-block"
           style="margin-top: 15px; padding: 10px; font-size: 16px;">
            <i class="fa fa-download"></i> Download QRIS
        </a>
    </div>
</div>

<div class="row">
    <div class="col-xs-12">
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-bolt"></i> Quick Actions</h3>
            </div>
            <div class="box-body">
                <div class="btn-group-wrapper">
                    <a href="{{ route('admin.servers') }}" class="quick-btn">
                        <i class="fa fa-server"></i>
                        <span>Servers</span>
                    </a>
                    <a href="{{ route('admin.users') }}" class="quick-btn">
                        <i class="fa fa-users"></i>
                        <span>Users</span>
                    </a>
                    <a href="{{ route('admin.nodes') }}" class="quick-btn">
                        <i class="fa fa-sitemap"></i>
                        <span>Nodes</span>
                    </a>
                    <a href="{{ route('admin.settings') }}" class="quick-btn">
                        <i class="fa fa-wrench"></i>
                        <span>Settings</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-history"></i> Recent Activities</h3>
                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse">
                        <i class="fa fa-minus"></i>
                    </button>
                </div>
            </div>
            <div class="box-body">
                <ul class="timeline timeline-compact">
                    <li class="time-label">
                        <span class="bg-blue">Today</span>
                    </li>
                    <li>
                        <i class="fa fa-server bg-aqua"></i>
                        <div class="timeline-item">
                            <span class="time"><i class="fa fa-clock-o"></i> 5 mins ago</span>
                            <h3 class="timeline-header">New server created</h3>
                            <div class="timeline-body">
                                Server "minecraft-server-01" has been created by Admin
                            </div>
                        </div>
                    </li>
                    <li>
                        <i class="fa fa-user bg-green"></i>
                        <div class="timeline-item">
                            <span class="time"><i class="fa fa-clock-o"></i> 12 mins ago</span>
                            <h3 class="timeline-header">New user registered</h3>
                            <div class="timeline-body">
                                User "john_doe" registered successfully
                            </div>
                        </div>
                    </li>
                    <li>
                        <i class="fa fa-warning bg-yellow"></i>
                        <div class="timeline-item">
                            <span class="time"><i class="fa fa-clock-o"></i> 27 mins ago</span>
                            <h3 class="timeline-header">Server resource warning</h3>
                            <div class="timeline-body">
                                Node "node-01" CPU usage at 85%
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="box-footer text-center">
                <a href="#" class="uppercase">View All Activities</a>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-tasks"></i> System Status</h3>
            </div>
            <div class="box-body">
                <div class="status-item">
                    <span class="status-label">CPU Usage</span>
                    <span class="status-value">45%</span>
                    <div class="progress progress-sm">
                        <div class="progress-bar progress-bar-success" style="width: 45%"></div>
                    </div>
                </div>
                <div class="status-item">
                    <span class="status-label">Memory Usage</span>
                    <span class="status-value">62%</span>
                    <div class="progress progress-sm">
                        <div class="progress-bar progress-bar-warning" style="width: 62%"></div>
                    </div>
                </div>
                <div class="status-item">
                    <span class="status-label">Disk Usage</span>
                    <span class="status-value">78%</span>
                    <div class="progress progress-sm">
                        <div class="progress-bar progress-bar-danger" style="width: 78%"></div>
                    </div>
                </div>
                <div class="status-item">
                    <span class="status-label">Network Load</span>
                    <span class="status-value">34%</span>
                    <div class="progress progress-sm">
                        <div class="progress-bar progress-bar-info" style="width: 34%"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Video Section -->
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-video-camera"></i> Media Showcase
                </h3>
            </div>
            <div class="box-body text-center">
                <div class="media-container">
                    <video id="autoVideo"
                        src="https://raw.githubusercontent.com/yopi-def/panel-installer/refs/heads/main/disk/84857c6fb0e7d00369c92a276e786c32.mp4"
                        autoplay
                        loop
                        muted
                        playsinline
                        preload="metadata">
                        Your browser does not support the video tag.
                    </video>
                    <div id="muteIndicator" class="video-mute-indicator">
                        <i class="fa fa-volume-up"></i>
                    </div>
                </div>
                <p class="text-muted" style="margin-top: 10px;">
                    <small><i class="fa fa-info-circle"></i> Double-click video untuk toggle sound</small>
                </p>
            </div>
        </div>
    </div>
</div>

<!-- Image Section -->
<div class="row">
    <div class="col-xs-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <i class="fa fa-picture-o"></i> Profile
                </h3>
            </div>
            <div class="box-body text-center">
                <div class="media-container">
                    <img src="https://raw.githubusercontent.com/yopi-def/panel-installer/refs/heads/main/disk/5dde106c93082395f9ef0abb0ae74453.jpg"
                         alt="Profile Image"
                         loading="lazy">
                </div>
            </div>
        </div>
    </div>
</div>

<script>
(function() {
    'use strict';
    
    // Video controls
    const video = document.getElementById('autoVideo');
    const muteIndicator = document.getElementById('muteIndicator');
    let lastTap = 0;
    
    video.addEventListener('click', function(e) {
        const currentTime = new Date().getTime();
        const tapGap = currentTime - lastTap;
        
        if (tapGap < 300 && tapGap > 0) {
            video.muted = !video.muted;
            
            // Show indicator
            muteIndicator.innerHTML = video.muted 
                ? '<i class="fa fa-volume-off"></i>' 
                : '<i class="fa fa-volume-up"></i>';
            muteIndicator.classList.add('show');
            
            setTimeout(() => {
                muteIndicator.classList.remove('show');
            }, 1000);
        }
        
        lastTap = currentTime;
    });
    
    // Modal controls
    const modal = document.getElementById('qrisModal');
    const btnDonasi = document.getElementById('btnDonasi');
    const closeModal = document.getElementById('closeModal');
    
    btnDonasi.addEventListener('click', function() {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevent scrolling
    });
    
    closeModal.addEventListener('click', function() {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    });
    
    // Close modal when clicking overlay (outside content)
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        }
    });
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && modal.classList.contains('active')) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        }
    });
})();
</script>
@endsection
EOF

chmod 644 "$REMOTE_PATH"