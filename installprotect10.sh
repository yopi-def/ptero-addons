#!/bin/bash

REMOTE_PATH="/var/www/pterodactyl/app/Http/Controllers/Admin/DatabaseController.php"
TIMESTAMP=$(date -u +"%Y-%m-%d-%H-%M-%S")
BACKUP_PATH="${REMOTE_PATH}.bak_${TIMESTAMP}"

if [ -f "$REMOTE_PATH" ]; then
  mv "$REMOTE_PATH" "$BACKUP_PATH"
fi

mkdir -p "$(dirname "$REMOTE_PATH")"
chmod 755 "$(dirname "$REMOTE_PATH")"

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
use Pterodactyl\Exceptions\DisplayException;

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
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses Database ditolak! Hanya Admin ID 1.');
        }

        return $this->view->make('admin.databases.index', [
            'databases' => $this->repository->getAllWithServers(),
        ]);
    }

    public function create(DatabaseFormRequest $request): RedirectResponse
    {
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses Database Create ditolak! Hanya Admin ID 1.');
        }

        $database = $this->creationService->handle($request->normalize());
        $this->alert->success('Database berhasil dibuat!')->flash();

        return redirect()->route('admin.databases.view', $database->id);
    }

    public function update(DatabaseFormRequest $request, Database $database): RedirectResponse
    {
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses Database Update ditolak! Hanya Admin ID 1.');
        }

        $this->updateService->handle($database->id, $request->normalize());
        $this->alert->success('Database berhasil diperbarui!')->flash();

        return redirect()->route('admin.databases.view', $database->id);
    }

    public function delete(Database $database): RedirectResponse
    {
        $user = Auth::user();
        if (!$user || $user->id !== 1) {
            abort(403, '🚫 Akses Database Delete ditolak! Hanya Admin ID 1.');
        }

        $this->deletionService->handle($database->id);
        $this->alert->success('Database berhasil dihapus!')->flash();

        return redirect()->route('admin.databases');
    }
}
EOF

chmod 644 "$REMOTE_PATH"
