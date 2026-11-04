<script>
    import gsap from 'gsap';
    import { goto } from '$app/navigation';
    import Input from '$lib/components/Input.svelte';
    import CircleButton from '$lib/components/CircleButton.svelte';

    let currentRole = $state('salarie');
    let mode = $state('login');
    let registerStep = $state(1);
    let email = $state('');
    let password = $state('');
    let companyName = $state('');
    let address = $state('');
    let siren = $state('');
    let objetSocial = $state('');
    let currentTitle = $derived( currentRole === 'partenaire' ? (mode === 'login' ? 'Partenaire' : 'Inscription Partenaire') : currentRole === 'salarie' ? 'Salarié' : 'Administration');
    let boxRef = $state();

    /** @type {Record<string, any>} */
    const roles = {
        salarie: {
            title: 'Salarié',
            desc: 'Gérez vos tickets, profitez de réductions et suivez votre solde en toute simplicité.',
            bgCard: 'bg-darkblue',
            colorText: 'text-darkblue',
            inputBg: 'border-white/40 text-white',
            btnBg: 'bg-white text-darkblue'
        },
        partenaire: {
            title: 'Partenaire',
            desc: 'Gérez votre établissement, suivez vos transactions et fidélisez vos clients facilement.',
            bgCard: 'bg-darkblue',
            colorText: 'text-darkblue',
            inputBg: 'text-gray-800 border-transparent',
            btnBg: 'bg-white text-darkblue'
        },
        admin: {
            title: 'Administration',
            desc: 'Supervisez l\'ensemble du réseau, validez les partenaires et gérez les abonnements.',
            bgCard: 'bg-darkblue',
            colorText: 'text-darkblue',
            inputBg: 'text-gray-800 border-transparent',
            btnBg: 'bg-white text-darkblue'
        }
    };

    const roleOrder = ['salarie', 'partenaire', 'admin'];

    /** @param {'salarie' | 'partenaire' | 'admin'} newRole */
    function switchRole(newRole) {
        if (newRole === currentRole)
            return;
        const currentIndex = roleOrder.indexOf(currentRole);
        const newIndex = roleOrder.indexOf(newRole);
        const isMovingRight = newIndex > currentIndex;
        const exitX = isMovingRight ? -400 : 400;
        const enterX = isMovingRight ? 400 : -400;
        const tl = gsap.timeline();

        tl.to(boxRef, { x: exitX, duration: 0.4, ease: "power2.in"});
        tl.add(() => { currentRole = newRole; mode = 'login'; registerStep = 1;});
        tl.set(boxRef, { x: enterX });
        tl.to(boxRef, { x: 0, duration: 0.6, ease: "power2.out"});
    }

    function handleMainAction() {
        if (mode === 'login') {
            if (currentRole === 'salarie') {
                goto("/employee/home");
                return;
            }
            alert(`Connexion (${currentRole}) pour ${email}`);
            return;
        }
        if (currentRole === 'partenaire') {
            if (registerStep === 1) {
                registerStep = 2;
            } else {
                alert(`Inscription partenaire soumise : ${companyName}, SIREN: ${siren}`);
            }
        } else {
            alert(`Inscription ${currentRole} pour ${email}`);
        }
    }

    function toggleMode() {
        mode = mode === 'login' ? 'register' : 'login';
        registerStep = 1;
    }
</script>

<div class="flex flex-col pl-7 pr-7 justify-around w-full h-screen bg-gray-50 transition-colors duration-500 overflow-hidden">
    <!-- En-tête -->
    <div class="flex justify-center items-center gap-x-4">
        <div class="w-12 h-12 rounded-full {roles[currentRole].bgCard} transition-colors duration-300"></div>
        <h1 class="text-[35px] font-[Mariane] font-extrabold {roles[currentRole].colorText} transition-colors duration-300">Ticket Tout</h1>
    </div>
    <!-- Carte principale -->
    <div bind:this={boxRef} class="{roles[currentRole].bgCard} rounded-xl w-full p-7 flex flex-col justify-around items-center transition-colors duration-300 shadow-xl min-h-125">
        <h1 class="font-[Mariane] text-[36px] text-white font-bold text-center">{currentTitle}</h1>
        {#if mode === 'login'}
            <p class="text-white text-[14px] text-center max-w-xs mb-4 opacity-90">{roles[currentRole].desc}</p>
        {/if}
        <!-- FORMULAIRES -->
        <div class="w-full flex flex-col gap-y-3">
            {#if mode === 'register' && currentRole === 'partenaire'}
                {#if registerStep === 1}
                    <!-- Partenaire Inscription Étape 1 -->
                    <Input label="Nom du partenaire" placeholder="Ex: Boulangerie Du Bon Pain" bind:value={companyName} class={roles[currentRole].inputBg} />
                    <Input label="Adresse de l'enseigne" placeholder="Ex: 12 rue de la République, Paris" bind:value={address} class={roles[currentRole].inputBg} />
                    <Input label="Email" type="email" placeholder="Ex: partenaire@tickettout.com" bind:value={email} class={roles[currentRole].inputBg} />
                {:else}
                    <!-- Partenaire Inscription Étape 2 -->
                    <Input label="Numéro de SIREN" placeholder="Ex: 123 456 789" bind:value={siren} class={roles[currentRole].inputBg} />
                    <Input label="Objet social" placeholder="Domaines précis d'actions" bind:value={objetSocial} class={roles[currentRole].inputBg} />
                {/if}
            {:else}
                <!-- Formulaire de Login classique -->
                <Input label="Email" type="email" placeholder="votre@email.com" icon="/images/mail.svg" bind:value={email} class={roles[currentRole].inputBg} />
                <Input label="Mot de passe" type="password" placeholder="••••••••" icon="/images/lock.svg" bind:value={password} class={roles[currentRole].inputBg} />
            {/if}
        </div>
        <!-- Bouton d'action principal -->
        <button onclick={handleMainAction} class="{roles[currentRole].btnBg} w-full h-14 rounded-2xl justify-center flex items-center text-[20px] font-[Mariane] font-extrabold hover:scale-105 transition duration-300 shadow-md mt-4 hover:cursor-pointer">
            {#if mode === 'login'}
                Login
            {:else if currentRole === 'partenaire' && registerStep === 1}
                Suivant
            {:else}
                Inscription
            {/if}
        </button>
        <!-- Bascule Login / Inscription (pour les partenaires) -->
        {#if currentRole === 'partenaire'}
            <button onclick={toggleMode} class="text-white text-xs underline mt-2 hover:opacity-80">{mode === 'login' ? 'Pas encore inscrit ? S\'inscrire' : 'Déjà inscrit ? Se connecter'}</button>
        {/if}
    </div>
    <!-- Sélecteur de rôle (les petits cercles bleus) -->
    <div class="flex justify-around items-center">
        <CircleButton bgColor="bg-darkblue" isActive={currentRole === 'salarie'} onclick={() => switchRole('salarie')}/>
        <CircleButton bgColor="bg-darkblue" isActive={currentRole === 'partenaire'} onclick={() => switchRole('partenaire')}/>
        <CircleButton bgColor="bg-darkblue" isActive={currentRole === 'admin'} onclick={() => switchRole('admin')}/>
    </div>
</div>