#!/bin/bash

# ======================================================
#        Fix / Restore DatabaseController
# ======================================================
# Author: Fhiya Frinella
# Purpose: Memperbaiki file DatabaseController yang rusak
# ======================================================

REMOTE_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/DatabaseController.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
BACKUP_PATH="${REMOTE_PATH}.bak_fix_${TIMESTAMP}"

# 1. Cek file DatabaseController ada atau tidak
if [ ! -f "$REMOTE_PATH" ]; then
    echo "❌ File DatabaseController.php tidak ditemukan di $REMOTE_PATH"
    exit 1
fi

# 2. Backup file rusak
cp "$REMOTE_PATH" "$BACKUP_PATH"
echo "📦 Backup file rusak dibuat di $BACKUP_PATH"

# 3. Restore versi default Laravel / clean version
cat > "$REMOTE_PATH" << 'EOF'
<?php

namespace Pterodactyl\Http\Controllers\Admin;

use Illuminate\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Pterodactyl\Models\Database;
use Pterodactyl\Services\Databases\DatabaseCreationService;
use Pterodactyl\Services\Databases\DatabaseDeletionService;
use Pterodactyl\Services\Databases\DatabaseUpdateService;
use Pterodactyl\Contracts\Repository\DatabaseRepositoryInterface;
use Prologue\Alerts\AlertsMessageBag;
use Illuminate\View\Factory as ViewFactory;
use Pterodactyl\Http\Controllers\Controller;
use Pterodactyl\Http\Requests\Admin\DatabaseFormRequest;

class DatabaseController extends Controller
{
    public function __construct(
        protected AlertsMessageBag $alert,
        protected DatabaseCreationService $creationService,
        protected DatabaseDeletionService $deletionService,
        protected DatabaseUpdateService $updateService,
        protected DatabaseRepositoryInterface $repository,
        protected ViewFactory $view
    ) {}

    public function index(): View
    {
        return $this->view->make('admin.databases.index', [
            'databases' => $this->repository->getAllWithServers(),
        ]);
    }

    public function create(DatabaseFormRequest $request): RedirectResponse
    {
        $database = $this->creationService->handle($request->normalize());
        $this->alert->success('Database berhasil dibuat!')->flash();

        return redirect()->route('admin.databases.view', $database->id);
    }

    public function update(DatabaseFormRequest $request, Database $database): RedirectResponse
    {
        $this->updateService->handle($database->id, $request->normalize());
        $this->alert->success('Database berhasil diperbarui!')->flash();

        return redirect()->route('admin.databases.view', $database->id);
    }

    public function delete(Database $database): RedirectResponse
    {
        $this->deletionService->handle($database->id);
        $this->alert->success('Database berhasil dihapus!')->flash();

        return redirect()->route('admin.databases');
    }
}
EOF

# 4. Set permission
chmod 644 "$REMOTE_PATH"

echo "✅ DatabaseController berhasil diperbaiki!"
echo "📂 Backup file lama: $BACKUP_PATH"
