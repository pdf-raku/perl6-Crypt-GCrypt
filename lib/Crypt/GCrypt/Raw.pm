use v6;

class Crypt::GCrypt::Raw {
    use NativeCall;
    use NativeCall::Types;

    sub find-lib is export(:find-lib) {
	$*VM.platform-library-name('gcrypt'.IO).Str;
    }

    my role Alloced[&destroy-sub] {
	submethod DESTROY {
	    &destroy-sub(self);
	}
    }

    #| see gcrypt.h, also gtrixie generated bindings in /etc/gcrypt.pm
    my constant gcry_int  is export = int32;
    my constant gcry_uint is export = uint32;

    my Int enum gcry_cipher_modes is export (
	GCRY_CIPHER_MODE_NONE => 0,
	GCRY_CIPHER_MODE_ECB => 1,
	GCRY_CIPHER_MODE_CFB => 2,
	GCRY_CIPHER_MODE_CBC => 3,
	GCRY_CIPHER_MODE_STREAM => 4,
	GCRY_CIPHER_MODE_OFB => 5,
	GCRY_CIPHER_MODE_CTR => 6,
	GCRY_CIPHER_MODE_AESWRAP => 7,
	GCRY_CIPHER_MODE_CCM => 8,
	GCRY_CIPHER_MODE_GCM => 9
    );

    my Int enum gcry_cipher_flags is export (
	GCRY_CIPHER_SECURE => 1,
	GCRY_CIPHER_ENABLE_SYNC => 2,
	GCRY_CIPHER_CBC_CTS => 4,
	GCRY_CIPHER_CBC_MAC => 8
    );

    my Int enum gcry_ctl_cmds is export (
	GCRYCTL_CFB_SYNC => 3,
	GCRYCTL_RESET => 4,
	GCRYCTL_FINALIZE => 5,
	GCRYCTL_GET_KEYLEN => 6,
	GCRYCTL_GET_BLKLEN => 7,
	GCRYCTL_TEST_ALGO => 8,
	GCRYCTL_IS_SECURE => 9,
	GCRYCTL_GET_ASNOID => 10,
	GCRYCTL_ENABLE_ALGO => 11,
	GCRYCTL_DISABLE_ALGO => 12,
	GCRYCTL_DUMP_RANDOM_STATS => 13,
	GCRYCTL_DUMP_SECMEM_STATS => 14,
	GCRYCTL_GET_ALGO_NPKEY => 15,
	GCRYCTL_GET_ALGO_NSKEY => 16,
	GCRYCTL_GET_ALGO_NSIGN => 17,
	GCRYCTL_GET_ALGO_NENCR => 18,
	GCRYCTL_SET_VERBOSITY => 19,
	GCRYCTL_SET_DEBUG_FLAGS => 20,
	GCRYCTL_CLEAR_DEBUG_FLAGS => 21,
	GCRYCTL_USE_SECURE_RNDPOOL => 22,
	GCRYCTL_DUMP_MEMORY_STATS => 23,
	GCRYCTL_INIT_SECMEM => 24,
	GCRYCTL_TERM_SECMEM => 25,
	GCRYCTL_DISABLE_SECMEM_WARN => 27,
	GCRYCTL_SUSPEND_SECMEM_WARN => 28,
	GCRYCTL_RESUME_SECMEM_WARN => 29,
	GCRYCTL_DROP_PRIVS => 30,
	GCRYCTL_ENABLE_M_GUARD => 31,
	GCRYCTL_START_DUMP => 32,
	GCRYCTL_STOP_DUMP => 33,
	GCRYCTL_GET_ALGO_USAGE => 34,
	GCRYCTL_IS_ALGO_ENABLED => 35,
	GCRYCTL_DISABLE_INTERNAL_LOCKING => 36,
	GCRYCTL_DISABLE_SECMEM => 37,
	GCRYCTL_INITIALIZATION_FINISHED => 38,
	GCRYCTL_INITIALIZATION_FINISHED_P => 39,
	GCRYCTL_ANY_INITIALIZATION_P => 40,
	GCRYCTL_SET_CBC_CTS => 41,
	GCRYCTL_SET_CBC_MAC => 42,
	GCRYCTL_ENABLE_QUICK_RANDOM => 44,
	GCRYCTL_SET_RANDOM_SEED_FILE => 45,
	GCRYCTL_UPDATE_RANDOM_SEED_FILE => 46,
	GCRYCTL_SET_THREAD_CBS => 47,
	GCRYCTL_FAST_POLL => 48,
	GCRYCTL_SET_RANDOM_DAEMON_SOCKET => 49,
	GCRYCTL_USE_RANDOM_DAEMON => 50,
	GCRYCTL_FAKED_RANDOM_P => 51,
	GCRYCTL_SET_RNDEGD_SOCKET => 52,
	GCRYCTL_PRINT_CONFIG => 53,
	GCRYCTL_OPERATIONAL_P => 54,
	GCRYCTL_FIPS_MODE_P => 55,
	GCRYCTL_FORCE_FIPS_MODE => 56,
	GCRYCTL_SELFTEST => 57,
	GCRYCTL_DISABLE_HWF => 63,
	GCRYCTL_SET_ENFORCED_FIPS_FLAG => 64,
	GCRYCTL_SET_PREFERRED_RNG_TYPE => 65,
	GCRYCTL_GET_CURRENT_RNG_TYPE => 66,
	GCRYCTL_DISABLE_LOCKED_SECMEM => 67,
	GCRYCTL_DISABLE_PRIV_DROP => 68,
	GCRYCTL_SET_CCM_LENGTHS => 69,
	GCRYCTL_CLOSE_RANDOM_DEVICE => 70,
	GCRYCTL_INACTIVATE_FIPS_FLAG => 71,
	GCRYCTL_REACTIVATE_FIPS_FLAG => 72
    );

    my constant gcry_cipher_handle is export = OpaquePointer;
    my constant gcry_cipher_hd_t is export = OpaquePointer;
    my constant gcry_md_hd_t is export = OpaquePointer;
    my constant gcry_error_t is export = OpaquePointer;
    my constant gpg_error_t is export = OpaquePointer;
    my constant gcry_ctl_cmd is export = gcry_uint;

    #/* Check that the library fulfills the version requirement.  */
    #const char *gcry_check_version (const char *req_version);
    our sub gcry_check_version(Pointer $null-pointer?)
        returns Str
        is export
        is native(&find-lib) { * }

    #/* Perform various operations defined by CMD. */
    #gcry_error_t gcry_control (enum gcry_ctl_cmds CMD, ...);
    sub gcry_control(gcry_ctl_cmd $CMD # gcry_ctl_cmds
                 ) is native(&find-lib) returns gpg_error_t is export { * }
    sub gcry_control2(gcry_ctl_cmd $CMD, gcry_int $, gcry_int $ # gcry_ctl_cmds
                 ) is native(&find-lib) is symbol('gcry_control') returns gpg_error_t is export { * }

    #/* Map the algorithm name NAME to an cipher algorithm ID.  Return 0 if
    #   the algorithm name is not known. */
    #int gcry_cipher_map_name (const char *name) _GCRY_GCC_ATTR_PURE;
    our sub gcry_cipher_map_name(Str $name)
        returns size_t
        is export
        is native(&find-lib) { * }

    #/* Map the algorithm NAME to a digest algorithm Id.  Return 0 if
    #   the algorithm name is not known. */
    #int gcry_md_map_name (const char* name) _GCRY_GCC_ATTR_PURE;
    our sub gcry_md_map_name(Str $name)
        returns size_t
        is export
        is native(&find-lib) { * }

    #/* Retrieve the key length in bytes used with algorithm A. */
    #size_t gcry_cipher_get_algo_keylen (int algo);
    our sub gcry_cipher_get_algo_keylen(gcry_int $algo)
        returns size_t
        is export
        is native(&find-lib) { * }

    #/* Retrieve the block length in bytes used with algorithm A. */
    #size_t gcry_cipher_get_algo_blklen (int algo);
    our sub gcry_cipher_get_algo_blklen(gcry_int $algo)
        returns size_t
        is export
        is native(&find-lib) { * }

    #/* Create a handle for algorithm ALGO to be used in MODE.  FLAGS may
#   be given as an bitwise OR of the gcry_cipher_flags values. */
#gcry_error_t gcry_cipher_open (gcry_cipher_hd_t *handle,
#                              int algo, int mode, unsigned int flags);
    sub gcry_cipher_open(gcry_cipher_handle $handle is rw # Typedef<gcry_cipher_hd_t>->|gcry_cipher_handle*|*
			 ,gcry_int                     $algo # int
			 ,gcry_int                     $mode # int
			 ,gcry_uint                    $flags # unsigned int
                     ) is native(&find-lib) returns gpg_error_t is export { * }
}
