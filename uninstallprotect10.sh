#!/bin/bash

REMOTE_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/DatabaseController.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
BACKUP_PATH="${REMOTE_PATH}.bak_unprotect_${TIMESTAMP}"

echo "🚀 Menghapus proteksi DatabaseController..."

# Backup file sebelum di-unprotect
if [ -f "$REMOTE_PATH" ]; then
    cp "$REMOTE_PATH" "$BACKUP_PATH"
    echo "📦 Backup file saat ini dibuat di $BACKUP_PATH"
fi

mkdir -p "$(dirname "$REMOTE_PATH")"
chmod 755 "$(dirname "$REMOTE_PATH")"

# Restore file default Laravel/awal tanpa proteksi
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

chmod 644 "$REMOTE_PATH"

echo "✅ Proteksi DatabaseController berhasil dihapus!"
echo "📂 Backup file saat unprotect: $BACKUP_PATH"